//
//  UIViewController+DreamLister.swift
//  Dream Lister
//
//  Created by AADITYA NARVEKAR on 7/1/17.
//  Copyright © 2017 Aaditya Narvekar. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func dismissKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
