//
//  UIImage.swift
//  PetPal
//
//  Created by Sabareesh Kappagantu on 5/16/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    enum ImageQuality: CGFloat{
        case lowest = 0
        case low = 0.25
        case medium = 0.5
        case high = 0.75
        case highest = 1
    }
    
    func jpeg(_ quality: ImageQuality) -> Data?{
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
    
}
