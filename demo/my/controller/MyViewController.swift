//
//  MyViewController.swift
//  demo
//
//  Created by 陈伟灿 on 2019/6/7.
//  Copyright © 2019 cwc. All rights reserved.
//

import UIKit


class MyViewController: UIViewController {
    
    private var nameLabel:UILabel?
    private var schoolLabel:UILabel?
    
    
    // 自定义导航栏
    private lazy var mNavigationBar : UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kNavigationH))
        view.backgroundColor = UIColor(red: 120 / 255, green: 158 / 255, blue: 248 / 255, alpha: 1)
        let title = UILabel(frame: CGRect(x: kScreenW/2-50, y: kNavigationH/2, width: 100, height: 50))
        title.text = "我的"
        title.textAlignment = .center
        title.textColor = UIColor.white
        view.addSubview(title)
        return view
    }();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let flag = UserDefaults.standard.bool(forKey: "login_flag")
        if(flag == false){
            nameLabel?.text = "登录"
            schoolLabel?.text = ""
        }else{
            let name = UserDefaults.standard.string(forKey: "login_name")
            let school = UserDefaults.standard.string(forKey: "login_school_name")
            nameLabel?.text = name!
            schoolLabel?.text = school!
        }
    }
    
    // 页面跳转 -
    @objc func openMapView(but: UIButton) {
        let mapView = MapViewController()
        // 隐藏底部导航栏
        mapView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mapView, animated: true)
    }
}

extension MyViewController{
    func setUI() {
        // 隐藏导航栏
        self.navigationController?.navigationBar.isHidden = true
        
        // 设置背景为白色
        self.view.backgroundColor = UIColor.white
        
        // 添加导航栏
        self.view.addSubview(mNavigationBar)
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: mNavigationBar.frame.height, width: kScreenW, height: kScreenH - kTabBarH - statusBarH))
        scrollView.backgroundColor = UIColor(red: 245/255, green: 247/255, blue: 249/255, alpha: 1)
        self.view.addSubview(scrollView)
        // 添加个人
        scrollView.addSubview(myBar())
        // 添加课程
        scrollView.addSubview(courseTableBar())
        // 添加活动
        scrollView.addSubview(activityBar())
        // 地图
        scrollView.addSubview(mapBar())
        // 添加设置
        scrollView.addSubview(seUpBar())
    }
}

extension MyViewController{
    // 个人
    func myBar()-> UIView{
        let mView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 100))
        mView.backgroundColor = UIColor.white
        // 头像
        let icon = UIImageView(frame: CGRect(x: 20, y: 10, width: 80, height: 80))
        icon.layer.cornerRadius = 40
        icon.image = UIImage(named: "my-icon")
        icon.layer.borderColor = UIColor(red: 245/255, green: 247/255, blue: 249/255, alpha: 1).cgColor
        icon.layer.borderWidth = 1
        // 单击事件监听
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(login))
        icon.addGestureRecognizer(singleTapGesture)
        icon.isUserInteractionEnabled = true
        
        mView.addSubview(icon)
        // 名字
        nameLabel = UILabel(frame: CGRect(x: 120, y: 30, width: 200, height: 30))
        nameLabel?.font = nameLabel?.font.withSize(20.0)
        nameLabel?.text = "登录"
        mView.addSubview(nameLabel!)
        // 学校
        schoolLabel = UILabel(frame: CGRect(x: 120, y: 60, width: 200, height: 30))
        schoolLabel?.font = schoolLabel?.font.withSize(10.0)
        schoolLabel?.text = ""
        mView.addSubview(schoolLabel!)
        // 二维码
        let qrCode = UIImageView(frame: CGRect(x: kScreenW - 70, y: 35, width: 30, height: 30))
        qrCode.image = UIImage(named: "qrcode")
        mView.addSubview(qrCode)
        return mView
    }
    
    // 课程表
    func courseTableBar()->UIView{
        let mView = UIView(frame: CGRect(x: 0, y: 130, width: kScreenW, height: 50))
        mView.backgroundColor = UIColor.white
        // 单击事件监听
//        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(setup))
//        mView.addGestureRecognizer(singleTapGesture)
//        mView.isUserInteractionEnabled = true
        // 左图标
        let leftImage = UIImageView(frame: CGRect(x: 10, y: 12, width: 25, height: 25))
        leftImage.image = UIImage(named: "coursetable")
        mView.addSubview(leftImage)
        // 标题
        let title = UILabel(frame: CGRect(x: 45, y: 10, width: 100, height: 30))
        title.text = "课程表"
        title.font = title.font.withSize(16.0)
        mView.addSubview(title)
        // 右图标
        let rightImage = UIImageView(frame: CGRect(x: kScreenW-35, y: 15, width: 20, height: 20))
        rightImage.image = UIImage(named: "right")
        mView.addSubview(rightImage)
        return mView
    }
    
    // 活动
    func activityBar()->UIView{
        let mView = UIView(frame: CGRect(x: 0, y: 181, width: kScreenW, height: 50))
        mView.backgroundColor = UIColor.white
        // 单击事件监听
        //        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(setup))
        //        mView.addGestureRecognizer(singleTapGesture)
        //        mView.isUserInteractionEnabled = true
        // 左图标
        let leftImage = UIImageView(frame: CGRect(x: 10, y: 12, width: 25, height: 25))
        leftImage.image = UIImage(named: "activity")
        mView.addSubview(leftImage)
        // 标题
        let title = UILabel(frame: CGRect(x: 45, y: 10, width: 100, height: 30))
        title.text = "活动"
        title.font = title.font.withSize(16.0)
        mView.addSubview(title)
        // 右图标
        let rightImage = UIImageView(frame: CGRect(x: kScreenW-35, y: 15, width: 20, height: 20))
        rightImage.image = UIImage(named: "right")
        mView.addSubview(rightImage)
        return mView
    }
    
    // 地图
    func mapBar()->UIView{
        let mView = UIView(frame: CGRect(x: 0, y: 232, width: kScreenW, height: 50))
        mView.backgroundColor = UIColor.white
        // 单击事件监听
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(openMap))
        mView.addGestureRecognizer(singleTapGesture)
        mView.isUserInteractionEnabled = true
        // 左图标
        let leftImage = UIImageView(frame: CGRect(x: 10, y: 12, width: 25, height: 25))
        leftImage.image = UIImage(named: "map")
        mView.addSubview(leftImage)
        // 标题
        let title = UILabel(frame: CGRect(x: 45, y: 10, width: 100, height: 30))
        title.text = "地图"
        title.font = title.font.withSize(16.0)
        mView.addSubview(title)
        // 右图标
        let rightImage = UIImageView(frame: CGRect(x: kScreenW-35, y: 15, width: 20, height: 20))
        rightImage.image = UIImage(named: "right")
        mView.addSubview(rightImage)
        return mView
    }
    
    // 设置
    func seUpBar()->UIView{
        let mView = UIView(frame: CGRect(x: 0, y: 283, width: kScreenW, height: 50))
        mView.backgroundColor = UIColor.white
        // 单击事件监听
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(setup))
        mView.addGestureRecognizer(singleTapGesture)
        mView.isUserInteractionEnabled = true
        // 左图标
        let leftImage = UIImageView(frame: CGRect(x: 10, y: 12, width: 25, height: 25))
        leftImage.image = UIImage(named: "seup")
        mView.addSubview(leftImage)
        // 标题
        let title = UILabel(frame: CGRect(x: 45, y: 10, width: 100, height: 30))
        title.text = "设置"
        title.font = title.font.withSize(16.0)
        mView.addSubview(title)
        // 右图标
        let rightImage = UIImageView(frame: CGRect(x: kScreenW-35, y: 15, width: 20, height: 20))
        rightImage.image = UIImage(named: "right")
        mView.addSubview(rightImage)
        return mView
    }
}

// 监听事件
extension MyViewController{
    @objc func login() {
        let flag = UserDefaults.standard.bool(forKey: "login_flag")
        if(flag == true){
            return
        }
        let loginView = LoginViewController()
        // 隐藏底部导航栏
        loginView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(loginView, animated: true)
    }
    
    // 页面跳转地图
    @objc func openMap() {
        let mapView = MapViewController()
        // 隐藏底部导航栏
        mapView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mapView, animated: true)
    }
    
    @objc func setup(){
        let setView = SetViewController()
        // 隐藏底部导航栏
        setView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(setView, animated: true)
    }
}
