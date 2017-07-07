//
//  RoundedCornersView.swift
//  Dream Lister
//
//  Created by AADITYA NARVEKAR on 6/18/17.
//  Copyright © 2017 Aaditya Narvekar. All rights reserved.
//

import UIKit

private var _roundedCorners: CGFloat! = 0.0

extension UIView {
    @IBInspectable var roundedCorners: CGFloat {
        get {
            return _roundedCorners
        }
        
        set {
            if newValue > 0 {
                _roundedCorners = newValue
            }
            
            if roundedCorners > 0 {
                self.layer.cornerRadius = roundedCorners
                self.layer.masksToBounds = true
            }
        }
    }
}
