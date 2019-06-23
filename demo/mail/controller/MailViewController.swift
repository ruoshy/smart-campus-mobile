//
//  MailViewController.swift
//  demo
//
//  Created by 陈伟灿 on 2019/6/20.
//  Copyright © 2019 cwc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MailViewController: UIViewController {
    
    private var stuJson : JSON?
    
    private var scrollView : UIScrollView?
    
    // 自定义导航栏
    private lazy var mNavigationBar : UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kNavigationH))
        view.backgroundColor = UIColor(red: 120 / 255, green: 158 / 255, blue: 248 / 255, alpha: 1)
        let title = UILabel(frame: CGRect(x: kScreenW/2-50, y: kNavigationH/2, width: 100, height: 50))
        title.text = "通讯录"
        title.textAlignment = .center
        title.textColor = UIColor.white
        view.addSubview(title)
        return view
    }();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        self.tabBarController?.tabBar.barStyle = .blackOpaque;
        self.tabBarController?.tabBar.isTranslucent = false;
        self.tabBarController?.tabBar.layer.shadowOpacity = 0.05
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let flag = UserDefaults.standard.bool(forKey: "login_flag")
        if(flag == false){

        }else{

        }
    }}

extension MailViewController{
    
    func setUI(){
        // 隐藏导航栏
        self.navigationController?.navigationBar.isHidden = true
        // 设置背景为白色
        self.view.backgroundColor = UIColor.white
        // 添加滚动视图 -1
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: kNavigationH, width: view.frame.width, height: kScreenH - kNavigationH - kTabBarH))
        scrollView.contentSize = CGSize(width: view.frame.width, height: 1000)
        scrollView.backgroundColor = UIColor(red: 245/255, green: 247/255, blue: 249/255, alpha: 1)
        view.addSubview(scrollView)

        // 添加导航栏
        view.addSubview(mNavigationBar)
        
        self.loadUsers()
    }

}

// 网络请求
extension MailViewController{
    func loadUsers(){
        let login_classs_id = UserDefaults.standard.string(forKey: "login_classs_id")
        Alamofire.request(webSite+"/admin/usrsl?classs_id=\(login_classs_id!)",method: .get)
            .responseJSON{response in
                let json = JSON(response.result.value as Any)
                self.stuJson = json
                var pos = 0
                for item in json{
                    let mView = UIButton(frame: CGRect(x: 0, y: pos * 81, width: Int(kScreenW), height: 80))
                    mView.tag = pos
                    mView.addTarget(self, action: #selector(self.select(but:)), for: .touchUpInside)
                    self.scrollView?.addSubview(mView)
                    mView.backgroundColor = UIColor.white
                    let iconView = UIImageView(frame: CGRect(x: 20, y: 20, width: 30, height: 30))
                    iconView.image = UIImage(named: "zlog")
                    mView.addSubview(iconView)
                    // 姓名
                    let nameLabel = UILabel(frame: CGRect(x: 70, y: 10, width: kScreenW - 40, height: 30))
                    mView.addSubview(nameLabel)
                    nameLabel.font = nameLabel.font.withSize(15)
                    nameLabel.text = item.1["name"].rawString()
                    // 底线
                    let line = UIView(frame: CGRect(x: 20, y: (pos+1) * 81, width: Int(kScreenW-90), height: 1))
                    self.scrollView?.addSubview(line)
                    line.backgroundColor = UIColor.lightGray
                    // 学号
                    let numberLabel = UILabel(frame: CGRect(x: 70, y: 45, width: kScreenW - 90, height: 20))
                    mView.addSubview(numberLabel)
                    numberLabel.font = numberLabel.font.withSize(12.0)
                    numberLabel.text = item.1["user"].rawString()
                    pos+=1
                }
                self.scrollView?.contentSize = CGSize(width: kScreenW, height: CGFloat(pos) * 81)
        }
    }
}

extension MailViewController{
    @objc func select(but: UIButton) {
        let chatView = ChatViewController()
        chatView.setInfo(id: stuJson![but.tag]["id"].rawString()!, name: stuJson![but.tag]["name"].rawString()!)
        // 隐藏底部导航栏
        chatView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chatView, animated: true)
    }
}
