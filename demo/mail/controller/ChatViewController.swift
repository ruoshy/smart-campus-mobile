//
//  ChatViewController.swift
//  demo
//
//  Created by 陈伟灿 on 2019/6/21.
//  Copyright © 2019 cwc. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    private var id : String?
    private var name : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }

    func setInfo(id:String,name:String){
        self.id = id
        self.name = name
    }
}

extension ChatViewController{
    func setUI() {
        // 隐藏导航栏
        self.navigationController?.navigationBar.isHidden = true
        
        // 添加自定义导航条
        let navigationBar = mNavigationBar()
        self.view.addSubview(navigationBar)
        
        // 添加滚动视图
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: kNavigationH, width: kScreenW, height: kScreenH - kNavigationH - 100))
        self.view.addSubview(scrollView)
        // 设置背景颜色
        scrollView.backgroundColor = UIColor(red: 245/255, green: 247/255, blue: 249/255, alpha: 1)
        // 添加底部视图
        self.view.addSubview(mBootomView())
        
        
    }
}

extension ChatViewController{
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
        let title = UILabel(frame: CGRect(x: kScreenW/2-50, y: kNavigationH/2, width: 100, height: 50))
        title.text = self.name
        title.textAlignment = .center
        mView.addSubview(title)
        return mView
    }
    
    func mBootomView()->UIView{
        let mView = UIView(frame: CGRect(x: 0, y: kScreenH - 100, width: kScreenW, height: 100))
        mView.backgroundColor = UIColor.white
        let text = UIView(frame: CGRect(x: 20, y: 20, width: kScreenW-40, height: 30))
        mView.addSubview(text)
        let line = UIView(frame: CGRect(x: 0, y: 55, width: kScreenW, height: 1))
        line.backgroundColor = UIColor.lightGray
        mView.addSubview(line)
        return mView
    }
}

// 事件监听
extension ChatViewController{
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
}
