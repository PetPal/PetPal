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
    
    var groups: [Group]! = []
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
            //locationManager.startUpdatingLocation()
        }
        
        mapView.showsUserLocation = true
        
        
        //set region
        
        let user = User.currentUser
        let location = user?.location! ?? "1 Infinite Loop, CA, USA" as String
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.geocodeAddressString(location,completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
            if ((placemarks?.count)! > 0) {
                let topResult: CLPlacemark = (placemarks?[0])!
                let placemark: MKPlacemark = MKPlacemark(placemark: topResult)
                let region = MKCoordinateRegionMake(CLLocationCoordinate2DMake((placemark.location?.coordinate.latitude)!,  (placemark.location?.coordinate.longitude)!),                                                  MKCoordinateSpanMake(0.3, 0.3))
                self.mapView.setRegion(region, animated: true)
                //self.mapView.addAnnotation(placemark)
            }
        })
        
        addPinsForGroups()
        
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
                let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 40000, 40000)
                mapView.setRegion(viewRegion, animated: false)
            }
        }
    }
    
    func addPinsForGroups(){
        PetPalAPIClient.sharedInstance.getGroups(success: { (groups: [Group]) in
            self.groups = groups
            for group in groups {
                let location = group.location!
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yy"
                let createdTime = "Created at: " + formatter.string(from: group.timeStamp!)
                let geocoder: CLGeocoder = CLGeocoder()
                geocoder.geocodeAddressString(location,completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
                    if ((placemarks?.count)! > 0) {
                        let topResult: CLPlacemark = (placemarks?[0])!
                        let placemark: MKPlacemark = MKPlacemark(placemark: topResult)
                        self.annotation.coordinate = (placemark.location?.coordinate)!
                        
                        let annotation = Annotation(title: group.name!, coordinate: (placemark.location?.coordinate)!, subtitle: createdTime)
                        self.mapView.addAnnotation(annotation)
                    }
                })
            }
        }) { (error: Error?) in
            print("error \(String(describing: error?.localizedDescription))")
        }
        
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
