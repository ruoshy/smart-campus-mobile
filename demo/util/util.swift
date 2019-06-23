//
//  util.swift
//  demo
//
//  Created by 陈伟灿 on 2019/6/21.
//  Copyright © 2019 cwc. All rights reserved.
//

import UIKit
import MJRefresh


func getDateFormatString(timeStamp:String) ->String{
    let interval:TimeInterval=TimeInterval.init(timeStamp)!
    
    
    let date = Date(timeIntervalSince1970: interval)
    let dateformatter = DateFormatter()
    //自定义日期格式
    dateformatter.dateFormat = "yyyy-MM-dd HH:mm"
    return dateformatter.string(from: date)
}


extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleToFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        let image = UIImage(data: imageData)
                        // Do something with your image.
                        DispatchQueue.main.async() { () -> Void in
                            self.image = image
                        }
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

extension UIScrollView {
    
    private struct RuntimeKey {
        static let HearderRefreshBlockKey = UnsafeRawPointer.init(bitPattern: "HearderRefreshBlockKey".hashValue)
        static let FooterRefreshBlockKey = UnsafeRawPointer.init(bitPattern: "FooterRefreshBlockKey".hashValue)
    }
    /// 下拉刷新的回调
    var hw_hearderRefreshBlock: (()->())? {
        set {
            if mj_header == nil { addHearderRefresh() } // 如果不存在 就自动添加
            objc_setAssociatedObject(self, UIScrollView.RuntimeKey.HearderRefreshBlockKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, UIScrollView.RuntimeKey.HearderRefreshBlockKey!) as? (()->())
        }
    }
    /// 上拉刷新的回调
    var hw_footerRefreshBlock: (()->())? {
        set {
            if mj_footer == nil { addFooterRefresh() } // 如果不存在 就自动添加
            objc_setAssociatedObject(self, UIScrollView.RuntimeKey.FooterRefreshBlockKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, UIScrollView.RuntimeKey.FooterRefreshBlockKey!) as? (()->())
        }
    }
    
    /// 单独使用下拉刷新
    private func addHearderRefresh() {
        let header = MJRefreshNormalHeader { [weak self] in
            if self == nil {return}
            if self?.mj_footer?.isRefreshing == true { // 如果上拉正在执行 将其结束
                self?.mj_footer?.endRefreshing()
            }
            if self?.mj_header?.isRefreshing == true {
                if self?.hw_hearderRefreshBlock == nil {return}
                self?.hw_hearderRefreshBlock!()
            }
        }
        mj_header = header
    }
    /// 单独使用上拉刷新
    private func addFooterRefresh() {
        let footer = MJRefreshBackNormalFooter { [weak self] in
            if self == nil {return}
            if self?.mj_header?.isRefreshing == true { // 如果下拉正在执行 将其结束
                self?.mj_header?.endRefreshing()
            }
            if self?.mj_footer?.isRefreshing == true {
                if self?.hw_footerRefreshBlock == nil {return}
                self?.hw_footerRefreshBlock!()
            }
        }
        mj_footer = footer
    }
    /// 结束刷新
    open func endRefreshing() {
        if mj_footer?.isRefreshing == true {
            mj_footer?.endRefreshing()
        }
        if mj_header?.isRefreshing == true  {
            mj_header?.endRefreshing()
        }
        
    }
    /// 开始刷新
    open func beginRefreshing() {
        mj_header?.beginRefreshing()
    }
}
