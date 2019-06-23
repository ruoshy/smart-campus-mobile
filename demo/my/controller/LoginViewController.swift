//
//  LoginViewController.swift
//  demo
//
//  Created by 陈伟灿 on 2019/6/20.
//  Copyright © 2019 cwc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    private var userText:UITextField? = nil
    private var pwdText:UITextField? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

}

extension LoginViewController{
    func setUI() {
        // 隐藏导航栏
        self.navigationController?.navigationBar.isHidden = true
        // 设置背景颜色
        self.view.backgroundColor = UIColor(red: 245/255, green: 247/255, blue: 249/255, alpha: 1)
        
        // 添加自定义导航条
        let navigationBar = mNavigationBar()
        self.view.addSubview(navigationBar)
        
        // 添加滚动视图
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: kNavigationH, width: kScreenW, height: kScreenH - kTabBarH - statusBarH))
        let loginView = getUserInView()
        scrollView.addSubview(loginView)
        // 输入框
        self.view.addSubview(scrollView)
        // 登录按钮
        let loginButton = getLoginButton()
        scrollView.addSubview(loginButton)
        // 添加logo图
        let logoView = UIImageView(frame: CGRect(x: kScreenW/2-25, y: 30, width: 50, height: 50))
        logoView.image = UIImage(named: "logo")
        scrollView.addSubview(logoView)
    }
}

extension LoginViewController{
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
        title.text = "登录"
        title.textAlignment = .center
        mView.addSubview(title)
        return mView
    }
    
    func getUserInView()->UIView{
        let mView = UIView(frame: CGRect(x: 10, y: 120, width: kScreenW - 20, height: 100))
        mView.backgroundColor = UIColor.white
        mView.layer.cornerRadius = 8
        // 账号输入框
        userText = UITextField(frame: CGRect(x: 10, y: 0, width: mView.frame.width - 20, height: 50))
        userText?.font = userText?.font?.withSize(14.0)
        userText?.placeholder = "请输入账号"
//        userText?.text="20172030321"
        userText?.autocapitalizationType = .none
        userText?.clearButtonMode = .whileEditing
        mView.addSubview(userText!)
        // 底线
        let line = UIView(frame: CGRect(x: 10, y: 50, width: mView.frame.width-20, height: 1))
        line.backgroundColor = UIColor.lightGray
        mView.addSubview(line)
        // 密码输入框
        pwdText = UITextField(frame: CGRect(x: 10, y: 50, width: mView.frame.width - 20, height: 50))
        pwdText?.font = pwdText?.font?.withSize(14.0)
        pwdText?.placeholder = "请输入密码"
        pwdText?.isSecureTextEntry = true
//        pwdText?.text="123456"
        pwdText?.autocapitalizationType = .none
        pwdText?.clearButtonMode = .whileEditing
        mView.addSubview(pwdText!)
        return mView
    }
    
    func getLoginButton() -> UIView {
        let mView = UIView(frame: CGRect(x: 10, y: 270, width: kScreenW-20, height: 40))
        mView.layer.cornerRadius = 3
        mView.backgroundColor = UIColor(red: 95/255, green: 155/255, blue: 240/255, alpha: 1)
        let title = UILabel(frame: CGRect(x: mView.frame.width/2-25, y: 5, width: 50, height: 30))
        title.text = "登录"
        title.textColor = UIColor.white
        title.textAlignment = .center
        mView.addSubview(title)
        // 单击事件监听
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(login))
        mView.addGestureRecognizer(singleTapGesture)
        mView.isUserInteractionEnabled = true
        return mView
    }
}

extension LoginViewController{
    func saveInfo(json:JSON) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(json["id"].stringValue, forKey: "login_id")
        userDefaults.set(json["user"].stringValue, forKey: "login_user")
        userDefaults.set(json["name"].stringValue, forKey: "login_name")
        userDefaults.set(json["classs_id"].stringValue, forKey: "login_classs_id")
        userDefaults.set(json["school_id"].stringValue, forKey: "login_school_id")
        userDefaults.set(json["school"]["name"].stringValue, forKey: "login_school_name")
        userDefaults.set(json["school"]["administrators"]["id"].stringValue, forKey: "admin_id")
        userDefaults.set(true, forKey: "login_flag")

        
        userDefaults.synchronize()
        self.navigationController?.popViewController(animated: true)
    }
}

// 事件监听
extension LoginViewController{
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func login(){
        Alamofire.request(webSite+"/login/stu",method: .post,parameters: ["user":userText!.text!,"password":pwdText!.text!,"name":"浙江经贸职业技术学院"], encoding: JSONEncoding.default, headers:["Content-Type": "application/json;charset=UTF-8"])
            .responseJSON{response in
                let json = JSON(response.result.value as Any)
                if(json.rawString() != "null"){
                    self.saveInfo(json: json)
                }
        }
    }
}
