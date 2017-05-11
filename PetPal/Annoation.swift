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

class Annotation: NSObject,MKAnnotation {
    
    var title : String?
    var subTit : String?
    var coordinate : CLLocationCoordinate2D
    
    init(title:String,coordinate : CLLocationCoordinate2D,subtitle:String){
        
        self.title = title;
        self.coordinate = coordinate;
        self.subTit = subtitle;
        
    }
    
}
