//
//  IndexController.swift
//  demo
//
//  Created by 陈伟灿 on 2019/6/7.
//  Copyright © 2019 cwc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

//  let lsLabel = view.viewWithTag(sender.view!.tag) as! UILabel

class IndexViewController: UIViewController ,UIScrollViewDelegate{
    
    // 分页导航栏属性
    private var pagingTitlePos : Int = 0
    private var pagingTitles : [UILabel] = []
    // 分页导航栏标题标题
    private let titles = ["简介","新闻"]
    // 分页导航栏滑动条
    private let slider = UILabel(frame: CGRect(x: kScreenW/4-10, y: 35, width: 17, height: 4))
    
    private var scrollView : UIScrollView?
    // 新闻数据
    private var newsJson : JSON?
    // 新闻视图
    private var newsScrollView : UIScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
//        self.tabBarController?.tabBar.layer.borderWidth = 0;
//        self.tabBarController?.tabBar.layer.borderColor = UIColor.red.cgColor
        self.tabBarController?.tabBar.barStyle = .blackOpaque;
        self.tabBarController?.tabBar.isTranslucent = false;
        self.tabBarController?.tabBar.layer.shadowOpacity = 0.05
    }
}

extension IndexViewController{
    
    func setUI(){
        // 隐藏导航栏
        self.navigationController?.navigationBar.isHidden = true
        // 设置背景为白色
        self.view.backgroundColor = UIColor.white
        // 添加顶部视图
        let headView = getHeadView()
        self.view.addSubview(headView)
        // 添加分页导航栏
        let pagingBar = getPagingBar()
        self.view.addSubview(pagingBar)
        
        // 添加滚动视图
        let mhigh = headView.frame.height+pagingBar.frame.height
        scrollView = UIScrollView(frame: CGRect(x: 0, y: statusBarH + mhigh, width: kScreenW, height: kScreenH - kTabBarH - statusBarH - mhigh))
        scrollView?.contentSize = CGSize(width: kScreenW * CGFloat(titles.count), height: kScreenH - kTabBarH - statusBarH - mhigh)
        scrollView?.isPagingEnabled = true
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.delegate = self
        view.addSubview(scrollView!)
        
        // 新闻页滚动视图
        newsScrollView = UIScrollView(frame: CGRect(x: kScreenW, y: 0, width: kScreenW, height: (scrollView?.frame.height)!))
        scrollView?.addSubview(newsScrollView!)
        newsScrollView?.hw_hearderRefreshBlock = { // 下拉刷新
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                self.loadNews(scrollView: self.newsScrollView!)
                self.newsScrollView?.endRefreshing()
            })
        }
        newsScrollView?.beginRefreshing()
        // 加载新闻页内容
        loadNews(scrollView : newsScrollView!)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        print("视图即将显示")
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        print("视图即将消失")
//    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pagingSliderHandle(tag: Int(scrollView.contentOffset.x / kScreenW))
    }
}

// 网络请求
extension IndexViewController{
    func loadNews(scrollView : UIScrollView){
        var reflag = false
        _ = scrollView.subviews.map {
            if(reflag){
               $0.removeFromSuperview()
            }
            reflag = true
        }
        let flag = UserDefaults.standard.bool(forKey: "login_flag")
        let admin_id = UserDefaults.standard.string(forKey: "admin_id")
        if(flag == true && admin_id != nil){
            Alamofire.request(webSite+"/admin/newsl?administrators_id=\(admin_id!)",method: .get)
                .responseJSON{response in
                    let json = JSON(response.result.value as Any)
                    self.newsJson = json
                    var lines = 0
                    for item in json{
                        let mView = UIButton(frame: CGRect(x: 0, y: 70*lines, width: Int(kScreenW), height: 70))
                        mView.tag = lines
                        mView.addTarget(self, action: #selector(self.selectNews(but:)), for: .touchUpInside)
                        scrollView.addSubview(mView)
                        // 下划线
                        let line = UIView(frame: CGRect(x: 0, y: 69, width: mView.frame.width, height: 1))
                        line.backgroundColor = UIColor.lightGray
                        line.layer.opacity = 0.3
                        mView.addSubview(line)
                        // 标题
                        let title = UILabel(frame: CGRect(x: 20, y: 10, width: kScreenW-40, height: 30))
                        title.font = title.font.withSize(13.0)
                        title.text = item.1["name"].rawString()
                        mView.addSubview(title)
                        // 日期
                        let date = UILabel(frame: CGRect(x: mView.frame.width-150, y: 40, width: 130, height: 30))
                        date.font = date.font.withSize(10.0)
                        date.textAlignment = .right
                        date.text = getDateFormatString(timeStamp: String(item.1["date"].rawString()!.prefix(10)))
                        mView.addSubview(date)
                        
                        lines+=1
                    }
                    scrollView.contentSize = CGSize(width: kScreenW, height: CGFloat(70*lines))
            }
        }
    }
}
// 顶部视图
extension IndexViewController{
    func getHeadView()-> UIView{
        let headView = UIView(frame: CGRect(x: 0, y: statusBarH, width: kScreenW, height: 90))
        // 标题lable
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        title.text = "首页"
        title.font = title.font.withSize(20)
        title.textAlignment = NSTextAlignment.center
        // 搜索框
        let searchView = UILabel(frame: CGRect(x: 20, y: 45, width: kScreenW - 40, height: 35))
        // 背景颜色
        searchView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        searchView.textColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        // 设置边框属性
        searchView.layer.shadowOpacity = 0.15
        searchView.layer.shadowOffset = CGSize(width: 1, height: 1)
        searchView.layer.borderColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1).cgColor
        searchView.layer.borderWidth = 1
        // 圆角边框
        searchView.layer.cornerRadius = 15
        searchView.clipsToBounds = true
        // 带不同属性的字符串
        var pstring:NSMutableAttributedString
        // 属性字符串
        var textAttachmentString:NSAttributedString
        // 文本附件
        var textAttachment:NSTextAttachment
        // 图文混排
        pstring = NSMutableAttributedString(string:" 搜索")
        textAttachment = NSTextAttachment()
        textAttachment.image = UIImage(named:"search")
        textAttachment.bounds = CGRect(x: 0, y: -2, width: 17, height: 17)
        textAttachmentString = NSAttributedString(attachment: textAttachment)
        pstring.insert(textAttachmentString, at: 0)
        searchView.attributedText = pstring
        // 设置文本属性
        searchView.font = title.font.withSize(15)
        searchView.textAlignment = NSTextAlignment.center
        
        headView.addSubview(title)
        headView.addSubview(searchView)
        return headView
    }
}


// 分页导航栏 -2
extension IndexViewController{
    func getPagingBar()-> UIView{
        let barView = UIView(frame: CGRect(x: 0, y: statusBarH + 90, width: kScreenW, height: 50))
        let xps = kScreenW / CGFloat(titles.count)
        for (index,value) in titles.enumerated(){
            let title = UILabel(frame: CGRect(x: xps * CGFloat(index) , y: 5, width: xps, height: 25))
            let tap = UITapGestureRecognizer(target: self, action: #selector(pagingSelect(sender:)))
            title.text = value
            if(index != 0){
                title.textColor = UIColor.gray
            }
            // 标识
            title.tag = index
            title.textAlignment = NSTextAlignment.center
            title.isUserInteractionEnabled = true
            title.addGestureRecognizer(tap)
            barView.addSubview(title)
            pagingTitles.append(title)
        }
        // 设置滑动条
        self.slider.backgroundColor = UIColor(red: 110/255, green: 158/255, blue: 244/255, alpha: 1)
        self.slider.layer.cornerRadius = 2
        self.slider.clipsToBounds = true
        
        barView.addSubview(self.slider)
        return barView
    }
    
    func pagingSliderHandle(tag : Int) {
        self.pagingTitles[pagingTitlePos].textColor = UIColor.gray
        self.pagingTitles[tag].textColor = UIColor.black
        self.pagingTitlePos = tag
        UIView.animate(withDuration: 0.3, delay:0.01, animations: {()-> Void in
            self.slider.frame.origin.x = kScreenW / CGFloat(self.titles.count * 2) - 8.5 + CGFloat(tag) * kScreenW/CGFloat(self.titles.count)
            self.scrollView?.contentOffset = CGPoint(x: kScreenW * CGFloat(tag), y: 0)

        })
    }
}

// 事件处理
extension IndexViewController{
    
    // 分页导航栏切换事件处理
    @objc func pagingSelect(sender: UITapGestureRecognizer) {
        self.pagingSliderHandle(tag: sender.view!.tag)
    }
    
    // 新闻选择
    @objc func selectNews(but: UIButton) {
        let newsView = NewsViewController()
        let date = getDateFormatString(timeStamp: String(newsJson![but.tag]["date"].rawString()!.prefix(10)))
        newsView.setNewsData(resource: newsJson![but.tag]["resource"].rawString()!,date: date)
        // 隐藏底部导航栏
        newsView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(newsView, animated: true)
    }
}


