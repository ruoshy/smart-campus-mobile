//
//  config.swift
//  demo
//
//  Created by 陈伟灿 on 2019/6/7.
//  Copyright © 2019 cwc. All rights reserved.
//
import UIKit


//状态栏高度
let statusBarH :CGFloat = UIApplication.shared.statusBarFrame.height;

//导航栏高度
let kNavigationH :CGFloat = (statusBarH + 44)

//tabbar高度
let kTabBarH :CGFloat = (statusBarH == 44 ? 83 : 49)

//顶部的安全距离
let kTopSafeAreaH :CGFloat = (statusBarH - 20)

//底部的安全距离
let kBottomSafeAreaH :CGFloat = (kTabBarH - 49)

let kScreenW :CGFloat = UIScreen.main.bounds.width
let kScreenH :CGFloat = UIScreen.main.bounds.height

let webSite:String = "http://localhost:8081"
