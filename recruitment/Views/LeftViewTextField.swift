//
//  LeftViewTextField.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 20/06/2018.
//  Copyright © 2018 IRIS Connect. All rights reserved.
//

import UIKit

class LeftViewTextField: UITextField {
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      self.configure()
   }
   
   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      self.configure()
   }
   
   private func configure() {
      self.leftViewMode = .always
   }
   
   override var leftView: UIView? {
      didSet {
         leftView?.contentMode = .left
         leftView?.tintAdjustmentMode = .normal
      }
   }
   
   override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
      let rect = super.leftViewRect(forBounds: bounds)
      return CGRect(x: rect.minX, y: rect.minY, width: 34, height: rect.height)
   }
}
