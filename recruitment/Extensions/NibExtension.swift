//
//  NibExtension.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 06/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import UIKit

// MARK: Nib

/**
 A set of properties that an object must fulfill to be able to be instantiated from a nib
 */
protocol NibInstantiable {
    /// The name of the nib file. The defualt value is the receiver type name
    static var nibName: String { get }
    
    /// The bundle where the bundle is conained. Default is the main bundle
    static var nibBundle: Bundle { get }
}

extension NibInstantiable {
    static var nibName: String {
        return String(describing: self)
    }
    
    static var nibBundle: Bundle {
        return Bundle.main
    }
    
    static var nib: UINib {
        return UINib(nibName: nibName, bundle: nibBundle)
    }
}

// MARK: UIView

extension NibInstantiable where Self: UIView {
    
    /**
     Instiante a view from a nib.
     - parameter nibName: The name of the nib where the view is. By Default it is the value of the nibName var.
     - parameter bundle: The bundle where the nib is contained. By Default it is the value of the nibBundle var.
     - returns: The fresh instance of the view
     */
    static func instantiate(nibName: String = Self.nibName,
                            bundle: Bundle = Self.nibBundle) -> Self {
        
        let array = bundle.loadNibNamed(nibName, owner: nil, options: nil)!
        return array.first as! Self
    }
    
}

// MARK: UIViewController

/**
 Instiante a view controller from a nib.
 - parameter nibName: The name of the nib where the view controller is. By Default it is the value of the nibName var.
 - parameter bundle: The bundle where the nib is contained. By Default it is the value of the nibBundle var.
 - returns: The fresh instance of the view controller
 */
extension NibInstantiable where Self: UIViewController {
    static func instantiate(nibName: String = Self.nibName,
                            bundle: Bundle = Self.nibBundle) -> Self {
        return Self(nibName: nibName, bundle: bundle)
    }
}
