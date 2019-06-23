//
//  NewsViewController.swift
//  demo
//
//  Created by 陈伟灿 on 2019/6/21.
//  Copyright © 2019 cwc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NewsViewController: UIViewController {
    private var newsId : String?
    private var newsName : String?
    private var newsDate : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    func setNewsData(resource: String,date:String){
        self.newsId = resource.components(separatedBy: "@")[0]
        self.newsName = resource.components(separatedBy: "@")[1]
        self.newsDate = date
    }
}

extension NewsViewController{
    func setUI() {
        // 隐藏导航栏
        self.navigationController?.navigationBar.isHidden = true
        // 设置背景颜色
        self.view.backgroundColor = UIColor(red: 245/255, green: 247/255, blue: 249/255, alpha: 1)
        
        // 添加自定义导航条
        let navigationBar = mNavigationBar()
        self.view.addSubview(navigationBar)
        
        // 添加滚动视图
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: kNavigationH, width: kScreenW, height: kScreenH - kNavigationH))
        scrollView.backgroundColor = UIColor.white
        self.view.addSubview(scrollView)
        
        // 标题
        let titleLable = UILabel(frame: CGRect(x: 20, y: 10, width: kScreenW - 40, height: 60))
        titleLable.font = UIFont.boldSystemFont(ofSize: 20)
        titleLable.numberOfLines = 2
        titleLable.text = self.newsName!
        scrollView.addSubview(titleLable)
        let dateLabel = UILabel(frame: CGRect(x: 20, y: 65, width: kScreenW-40, height: 30))
        dateLabel.text = self.newsDate
        dateLabel.font = dateLabel.font.withSize(13.0)
        dateLabel.textColor = UIColor.gray
        scrollView.addSubview(dateLabel)
        // 请求网络数据
        let name_urlcode = self.newsName!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        Alamofire.request(webSite+"/admin/ifnew?administrators_id=\(self.newsId!)&name=\(name_urlcode!)",method: .get)
            .responseJSON{response in
                let json = JSON(response.result.value as Any)
                var totalHeight : CGFloat = 0
                for item in json{
                    if(item.1["type"] == 0){
                        let content = UILabel(frame: CGRect(x: 20, y: 120 + totalHeight, width: kScreenW - 40, height: 10))
                        let paraph = NSMutableParagraphStyle()
                        paraph.lineSpacing = 8
                        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15),NSAttributedString.Key.paragraphStyle: paraph]
                        content.attributedText = NSAttributedString(string: item.1["cten"].rawString()!, attributes: attributes)
                        content.numberOfLines = 0
                        content.sizeToFit()
                        scrollView.addSubview(content)
                        totalHeight += content.frame.height
                    }else{
                        totalHeight += 20
                        let img_name = item.1["name"].rawString()
                        let multiple =  (kScreenW-40) / CGFloat(NSString(string:img_name!.components(separatedBy: "_")[0]).integerValue)
                        let img_height = CGFloat(NSString(string:img_name!.components(separatedBy: "_")[1]).floatValue) * multiple
                        
                        let img = UIImageView(frame: CGRect(x: 20, y: 120 + totalHeight, width: kScreenW-40, height: img_height))
                        scrollView.addSubview(img)
                        if let url = URL(string: "\(webSite)/image/\(self.newsId!)@\(name_urlcode!)/\(img_name!)") {
                            img.downloadedFrom(url: url)
                        }
                        
                        totalHeight += img.frame.height + 20
                    }
                }
                scrollView.contentSize = CGSize(width: kScreenW, height: totalHeight + 120)
        }
    }
}

extension NewsViewController{
    func mNavigationBar()->UIView{
        let mView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kNavigationH))
        mView.backgroundColor = UIColor.white
        // 左视图
        let leftView = UIView(frame: CGRect(x: 10, y: kNavigationH/2+8, width: 70, height: 30))
        // 单击事件监听
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(back))
        leftView.addGestureRecognizer(singleTapGesture)
        leftView.isUserInteractionEnabled = true
        mView.addSubview(leftView)
        // 返回图标
        let backImage = UIImageView(frame: CGRect(x: 0, y: 5, width: 20, height: 20))
        backImage.image = UIImage(named: "left")
        leftView.addSubview(backImage)
        // 标题
        let leftTitle = UILabel(frame: CGRect(x: 22, y: 0, width: 50, height: 30))
        leftTitle.text = "返回"
        leftView.addSubview(leftTitle)
        // 中间内容
        let title = UILabel(frame: CGRect(x: kScreenW/2-25, y: kNavigationH/2, width: 50, height: 50))
        title.text = ""
        title.textAlignment = .center
        mView.addSubview(title)
        return mView
    }
}

// 事件监听
extension NewsViewController{
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
}
