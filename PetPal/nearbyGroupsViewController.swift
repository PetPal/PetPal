//
//  NearbyGroupsViewController.swift
//  PetPal
//
//  Created by Rui Mao on 5/3/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class NearbyGroupsViewController: UIViewController,  MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let annotation = MKPointAnnotation()
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 157/256, green: 169/256, blue: 61/256, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor.white

        
        mapView.delegate = self
        locationManager = CLLocationManager()
        locationManager.delegate = self 
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        mapView.showsUserLocation = true
        
        addPin()
        
        // Do any additional setup after loading the view.
        //let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),
          //                                    MKCoordinateSpanMake(0.1, 0.1))
        //self.mapView.setRegion(sfRegion, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { currentLocation = locations.last }
       // let currentLocation =
        if currentLocation == nil {
            // Zoom to user location
            if let userLocation = locations.last {
                let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 5000, 5000)
                mapView.setRegion(viewRegion, animated: false)
            }
        }
    }
    
    func addPin(){
        let location: String = "1 infinite loop, CA, USA"
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.geocodeAddressString(location,completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
            if ((placemarks?.count)! > 0) {
                let topResult: CLPlacemark = (placemarks?[0])!
                let placemark: MKPlacemark = MKPlacemark(placemark: topResult)
                let region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.368832,  -122.036346),                                                  MKCoordinateSpanMake(0.3, 0.3))
                self.mapView.setRegion(region, animated: true)
                self.annotation.coordinate = (placemark.location?.coordinate)!
                self.mapView.addAnnotation(self.annotation)
            }
        })
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
