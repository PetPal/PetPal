//
//  CAGradientLayer+Convenience.swift
//  PetPal
//
//  Created by Sabareesh Kappagantu on 5/7/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import Foundation
import UIKit

extension CAGradientLayer {
    
    func gradientBackground(topColor: CGColor, bottomColor: CGColor) -> CAGradientLayer {
        
        let gradientColors: [CGColor] = [topColor, bottomColor]
        let gradientLocations: [NSNumber] = [0.0, 1.0]
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        return gradientLayer
    }
}

