//
//  SetViewController.swift
//  demo
//
//  Created by 陈伟灿 on 2019/6/21.
//  Copyright © 2019 cwc. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}

extension SetViewController{
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
        self.view.addSubview(scrollView)
        
        // 添加退出栏
        scrollView.addSubview(outBar())
    }
}

extension SetViewController{
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
        title.text = "设置"
        title.textAlignment = .center
        mView.addSubview(title)
        return mView
    }
    
    // 退出
    func outBar()->UIView{
        let mView = UIView(frame: CGRect(x: 0, y: 1, width: kScreenW, height: 50))
        mView.backgroundColor = UIColor.white
        // 单击事件监听
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(outUser))
        mView.addGestureRecognizer(singleTapGesture)
        mView.isUserInteractionEnabled = true
        // 标题
        let title = UILabel(frame: CGRect(x: 0, y: 10, width: kScreenW, height: 30))
        title.text = "退出账号"
        title.textAlignment = .center
        title.font = title.font.withSize(16.0)
        mView.addSubview(title)
        return mView
    }
}

// 事件监听
extension SetViewController{
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func outUser(){
        let userDefaults = UserDefaults.standard
        userDefaults.set(false, forKey: "login_flag")
        userDefaults.synchronize()
        back()
    }
}
