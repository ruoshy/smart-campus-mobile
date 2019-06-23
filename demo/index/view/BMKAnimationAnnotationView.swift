//
//  BMKAnimationAnnotationView.swift
//  BMKSwiftDemo
//
//  Created by Baidu RD on 2018/7/23.
//  Copyright © 2018年 Baidu. All rights reserved.
//

import UIKit

class BMKAnimationAnnotationView: BMKAnnotationView {
    
    override init!(annotation: BMKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        let annotationImage = UIImageView(frame: self.frame)
        annotationImage.animationImages = [UIImage(named: "blackAnimationIcon")!]
        annotationImage.animationDuration = 0.5 * 3
        annotationImage.animationRepeatCount = 0
        annotationImage.startAnimating()
        addSubview(annotationImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

