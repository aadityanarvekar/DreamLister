//
//  MaterialView.swift
//  Dream Lister
//
//  Created by AADITYA NARVEKAR on 6/17/17.
//  Copyright © 2017 Aaditya Narvekar. All rights reserved.
//

import UIKit

private var _materialKey: Bool! = false
extension UIView {
    
    @IBInspectable var materialKey: Bool {
        get {
            return _materialKey
        }
        
        set {
            _materialKey = true
            
            if materialKey {
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 3.0
                self.layer.shadowOpacity = 0.8
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                self.layer.shadowColor = UIColor.black.cgColor                
            }
        }
    }
}
