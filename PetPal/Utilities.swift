//
//  File.swift
//  PetPal
//
//  Created by Rui Mao on 4/29/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import Foundation
import UIKit
import Parse


class Utilities {
    
    class func presentHamburgerView(window: UIWindow?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let hamburgerVC = storyboard.instantiateViewController(withIdentifier: "HamburgerViewController") as! HamburgerViewController
        let menuVC = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        
        hamburgerVC.menuViewController = menuVC
        menuVC.hamburgerViewController = hamburgerVC

        window?.rootViewController = hamburgerVC
    }
    
    class func loginUser(_ target: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeVC = storyboard.instantiateViewController(withIdentifier: "navigationVC") as! UINavigationController
        target.present(welcomeVC, animated: true, completion: nil)
        
    }
    
    class func logoutUser() {
        PFUser.logOutInBackground()
        User.currentUser = nil

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
        if let keyWindow = UIApplication.shared.keyWindow {
            keyWindow.rootViewController = welcomeVC
        }
        
    }
    
    class func postNotification(_ notification: String) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: notification), object: nil)
    }
    
    class func timeElapsed(_ seconds: TimeInterval) -> String {
        var elapsed: String
        if seconds < 60 {
            elapsed = "Just now"
        }
        else if seconds < 60 * 60 {
            let minutes = Int(seconds / 60)
            let suffix = (minutes > 1) ? "mins" : "min"
            elapsed = "\(minutes) \(suffix) ago"
        }
        else if seconds < 24 * 60 * 60 {
            let hours = Int(seconds / (60 * 60))
            let suffix = (hours > 1) ? "hours" : "hour"
            elapsed = "\(hours) \(suffix) ago"
        }
        else {
            let days = Int(seconds / (24 * 60 * 60))
            let suffix = (days > 1) ? "days" : "day"
            elapsed = "\(days) \(suffix) ago"
        }
        return elapsed
    }
    
    class func formatStartEndDate(startDate: Date, endDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let startMonth = formatter.string(from: startDate)
        let endMonth = formatter.string(from: endDate)
        if startMonth == endMonth {
            formatter.dateFormat = "d"
            let startDay = formatter.string(from: startDate)
            let endDay = formatter.string(from: endDate)
            
            return startMonth + " " + startDay + " - " + endDay
        } else {
            formatter.dateFormat = "MMMM d"
            let startDay = formatter.string(from: startDate)
            let endDay = formatter.string(from: endDate)
            
            return startDay + " - " + endDay
        }
    }
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
}


