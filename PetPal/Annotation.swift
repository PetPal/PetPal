//
//  Annoation.swift
//  PetPal
//
//  Created by Rui Mao on 5/11/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import Foundation

import UIKit
import MapKit
import ParseUI

class Annotation: NSObject, MKAnnotation {
    
    var title : String?
    var subtitle : String?
    var coordinate : CLLocationCoordinate2D
    var pinCustomImageName: String!
    var group: Group?
    
    init(title:String, coordinate : CLLocationCoordinate2D){
        self.title = title
        self.coordinate = coordinate
    }
    
}
