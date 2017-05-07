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
        
          self.borderStyle = UITextBorderStyle.none
          self.frame = CGRect(x: Int(self.frame.origin.x), y: Int(self.frame.origin.y), width: Int(self.frame.size.width), height: 50)
          self.backgroundColor = UIColor.clear
          self.textColor = UIColor.black
        
        //Font
        self.font = UIFont(name: (self.font?.fontName)!, size: 15)
    }
}
