//
//  TwoViewController.swift
//  demo
//
//  Created by 陈伟灿 on 2019/6/9.
//  Copyright © 2019 cwc. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, BMKMapViewDelegate, BMKLocationManagerDelegate {
    
    let annotationViewIdentifier = "com.Baidu.BMKAnimationAnnotaiton"
    var userLocation: BMKUserLocation = BMKUserLocation()
    
    //MARK:Lazy loading
    private lazy var mapView: BMKMapView = {
        let mapView = BMKMapView(frame: CGRect(x: 0, y: kNavigationH, width: kScreenW, height: kScreenH-kNavigationH))
        mapView.isOverlookEnabled = false
        //设置mapView的代理
        mapView.delegate = self
        return mapView
    }()
    
    private lazy var polygon: BMKPolygon = {
        var coors = [CLLocationCoordinate2D]()
        
        coors.append(CLLocationCoordinate2D(latitude: 30.324659, longitude: 120.385955))
        coors.append(CLLocationCoordinate2D(latitude: 30.324628, longitude: 120.392082))
        coors.append(CLLocationCoordinate2D(latitude: 30.32003, longitude: 120.392064))
        coors.append(CLLocationCoordinate2D(latitude: 30.320092, longitude: 120.389081))
        coors.append(CLLocationCoordinate2D(latitude: 30.321963, longitude: 120.387392))
        coors.append(CLLocationCoordinate2D(latitude: 30.322867, longitude: 120.38529))
        coors.append(CLLocationCoordinate2D(latitude: 30.324659, longitude: 120.385955))
        
        
        let polygon: BMKPolygon = BMKPolygon(coordinates: &coors, count: 7)
        return polygon
    }()
    
    // 自定义导航栏
    private lazy var mNavigationBar : UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kNavigationH))
        view.backgroundColor = UIColor(red: 120 / 255, green: 158 / 255, blue: 248 / 255, alpha: 1)
        return view
    }();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate heading: CLHeading?) {
        NSLog("用户方向更新")
//        userLocation.heading = heading
//        mapView.updateLocationData(userLocation)
    }
    
    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate location: BMKLocation?, orError error: Error?) {
        if let _ = error?.localizedDescription {
            NSLog("locError:%@;", (error?.localizedDescription)!)
        }
        userLocation.location = location?.location
        //实现该方法，否则定位图标不出现
        mapView.updateLocationData(userLocation)
    }
    
    func bmkLocationManager(_ manager: BMKLocationManager, didFailWithError error: Error?) {
        NSLog("定位失败")
    }
    
    lazy var locationManager: BMKLocationManager = {
        //初始化BMKLocationManager的实例
        let manager = BMKLocationManager()
        //设置定位管理类实例的代理
        manager.delegate = self
        //设定定位坐标系类型，默认为 BMKLocationCoordinateTypeGCJ02 BMK09LL
        manager.coordinateType = BMKLocationCoordinateType.BMK09LL
        //设定定位精度，默认为 kCLLocationAccuracyBest
        manager.desiredAccuracy = kCLLocationAccuracyBest
        //设定定位类型，默认为 CLActivityTypeAutomotiveNavigation
        manager.activityType = CLActivityType.automotiveNavigation
        //指定定位是否会被系统自动暂停，默认为NO
        manager.pausesLocationUpdatesAutomatically = false
        /**
         是否允许后台定位，默认为NO。只在iOS 9.0及之后起作用。
         设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。
         由于iOS系统限制，需要在定位未开始之前或定位停止之后，修改该属性的值才会有效果。
         */
        manager.allowsBackgroundLocationUpdates = true
        /**
         指定单次定位超时时间,默认为10s，最小值是2s。注意单次定位请求前设置。
         注意: 单次定位超时时间从确定了定位权限(非kCLAuthorizationStatusNotDetermined状态)
         后开始计算。
         */
        manager.locationTimeout = 10
        manager.reGeocodeTimeout = 10;
        return manager
    }()
    
    @objc func openTwe(but: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MapViewController{
    func setUI() {
        // 设置背景为白色
        self.view.backgroundColor = UIColor.white
        
        // 添加导航栏
        self.view.addSubview(mNavigationBar)
        
        // 添加返回按钮
        let backbut = UIButton(frame: CGRect(x: 10, y: statusBarH + 5, width: 50, height: 30))
        backbut.setTitle("返回", for: .normal)
        backbut.addTarget(self, action: #selector(openTwe(but:)), for: .touchDown)
        view.addSubview(backbut)
        
        // 添加地图
        self.view.addSubview(mapView)
        let center = CLLocationCoordinate2D(latitude: 30.3223600461, longitude: 120.3890319713)
        mapView.centerCoordinate = center
        //        // 设置区域
        let span = BMKCoordinateSpanMake(0.011929035022411938, 0.0078062748817018246)
        let region = BMKCoordinateRegionMake(center, span)
        mapView.setRegion(region, animated: true)
        
        //        let annotation = BMKPointAnnotation.init()
        //        annotation.coordinate =  CLLocationCoordinate2D(latitude: 30.322867, longitude: 120.389476)
        //        annotation.title = "标注"
        //        annotation.subtitle = "可拖拽"
        //        mapView.addAnnotation(annotation)
        mapView.add(polygon)
        
        
        mapView.userTrackingMode = BMKUserTrackingModeNone
       
        
        //显示定位图层
        mapView.showsUserLocation = true
        
        //开启定位服务
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
        
        
        let bdp = BMKLocationViewDisplayParam()
//        bdp.isAccuracyCircleShow = false
        //        bdp.locationViewOffsetX = 0.3;//定位偏移量(经度)
        //        bdp.locationViewOffsetY = 0.3;//定位偏移量（纬度
        mapView.updateLocationView(with: bdp)
        
        
        
    }
}

extension MapViewController{
    func mapView(_ mapView: BMKMapView!, viewFor overlay: BMKOverlay!) -> BMKOverlayView! {
        if overlay.isKind(of: BMKPolygon.self) {
            //初始化一个overlay并返回相应的BMKPolygonView的实例
            let polygonView = BMKPolygonView(polygon: polygon)
            //设置polygonView的画笔（边框）颜色
            polygonView?.strokeColor = UIColor.init(red: 1, green: 0, blue: 0, alpha: 1)
            //设置polygonView的填充色
            polygonView?.fillColor = UIColor.init(red: 1, green: 0, blue: 0, alpha: 0)
            //设置polygonView的线宽度
            polygonView?.lineWidth = 2.0
            //设置polygonView为虚线样式
            polygonView?.lineDash = true
            return polygonView
        }
        return nil
    }
    
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        /**
         根据指定标识查找一个可被复用的标注，用此方法来代替新创建一个标注，返回可被复用的标注
         */
        var annotationView: BMKAnimationAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: annotationViewIdentifier) as? BMKAnimationAnnotationView
        if annotationView == nil {
            /**
             初始化并返回一个annotationView
             
             @param annotation 关联的annotation对象
             @param reuseIdentifier 如果要重用view，传入一个字符串，否则设为nil，建议重用view
             @return 初始化成功则返回annotationView，否则返回nil
             */
            annotationView = BMKAnimationAnnotationView.init(annotation: annotation, reuseIdentifier: annotationViewIdentifier)
            //自定义标注的图片，默认图片是大头针
            return annotationView
        }
        return nil
    }
    
    
}

extension MapViewController{
}
