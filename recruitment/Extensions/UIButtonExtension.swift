//
//  UIButtonExtension.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 11/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import Foundation
import UIKit


extension UIView{
    func rounded(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft , .topRight, .bottomLeft, .bottomRight],
                                     cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    func circle(){
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.clipsToBounds = true
    }
}
