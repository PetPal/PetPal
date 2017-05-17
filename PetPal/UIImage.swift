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
    
    func jpeg(_ quality: ImageQuality) -> UIImage?{
        let imageData = UIImageJPEGRepresentation(self, quality.rawValue)
        if let data = imageData {
            return UIImage(data: data)
        }
        return nil
    }
    
    func compress() -> UIImage?{
        let imageToBeCompressed = self.scaleImage()
        var compression: CGFloat = 0.99
        let maxFileSize = 1024 * 600
        var compressMore = true
        var imageData: Data?
        
        while (compressMore) {
            if let data:Data = UIImageJPEGRepresentation(imageToBeCompressed!, compression) {
                if data.count < maxFileSize {
                    compressMore = false
                    imageData = data
                    print("Image is small enough and has been compressed \(imageData?.count)")
                } else {
                    print("Image is still large, and needs to be compressed further \(data.count)")
                    compression = compression - 0.1
                }
            }
        }
        
        if let data = imageData {
            print("Final Image size: \(data.count)")
            return UIImage(data: data)
        }
        
        return nil
    }
    
    func scaleImage() -> UIImage?{
        let originalSize = self.size
        let newSize = CGSize(width: originalSize.width * 0.5, height: originalSize.height * 0.5)
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}
