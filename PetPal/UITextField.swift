//
//  UITextField.swift
//  PetPal
//
//  Created by Sabareesh Kappagantu on 5/1/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func signupTextBox() {
        let border = CALayer()
        let borderWidth = CGFloat(0.5)
        border.borderColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width: self.frame.size.width, height: 40)
        border.borderWidth = borderWidth
        self.borderStyle = UITextBorderStyle.none
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
        self.backgroundColor = UIColor.clear
        self.textColor = UIColor.white
        
        //Font
        self.font = UIFont(name: (self.font?.fontName)!, size: 15)
    }
}
