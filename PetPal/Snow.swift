//
//  Snow.swift
//  PetPal
//
//  Created by Rui Mao on 5/16/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class SnowView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let emitter = layer as! CAEmitterLayer
        emitter.emitterPosition = CGPoint(x: bounds.size.width / 2, y: 0)
        emitter.emitterSize = bounds.size
        emitter.emitterShape = kCAEmitterLayerRectangle
        
        let emitterCell = CAEmitterCell()
        emitterCell.contents = UIImage(named: "clover.png")!.cgImage
        emitterCell.birthRate = 2
        emitterCell.lifetime = 5
        emitterCell.color = UIColor.white.cgColor
        emitterCell.redRange = 0.0
        emitterCell.blueRange = 0.1
        emitterCell.greenRange = 0.0
        emitterCell.velocity = 0.1
        emitterCell.velocityRange = 5
        emitterCell.emissionRange = CGFloat(Double.pi/2)
        emitterCell.emissionLongitude = CGFloat(-Double.pi)
        emitterCell.yAcceleration = 60
        emitterCell.xAcceleration = 15
        emitterCell.scale = 0.33
        emitterCell.scaleRange = 1.25
        emitterCell.scaleSpeed = -0.25
        emitterCell.alphaRange = 0.5
        emitterCell.alphaSpeed = -0.15
        
        emitter.emitterCells = [emitterCell]
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var layerClass: AnyClass {
        return CAEmitterLayer.self
    }
    
}
