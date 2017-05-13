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

class NearbyGroupsViewController: UIViewController,  MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var mapView: MKMapView!
    let annotation = MKPointAnnotation()
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    var pinAnnotationView:MKPinAnnotationView!
    
    var groups: [Group]! = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
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
        loadGroups()
        addPinsForGroups()
        // register tableView Cell
        let nibName = UINib(nibName: "GroupCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "GroupCell")
        
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
    
    func loadGroups(){
        PetPalAPIClient.sharedInstance.getGroups(success: { (groups: [Group]) in
            self.groups = groups
            self.tableView.reloadData()
        }) { (error: Error?) in
            print("error \(String(describing: error?.localizedDescription))")
        }
    }

    func addPinsForGroups(){
        PetPalAPIClient.sharedInstance.getGroups(success: { (groups: [Group]) in
            self.groups = groups
            for group in groups {
                let location = group.location!
                //let formatter = DateFormatter()
                //formatter.dateFormat = "MM/dd/yy"
                //let createdTime = "Created at: " + formatter.string(from: group.timeStamp!)
                let geocoder: CLGeocoder = CLGeocoder()
                geocoder.geocodeAddressString(location,completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
                    if ((placemarks?.count)! > 0) {
                        let topResult: CLPlacemark = (placemarks?[0])!
                        let placemark: MKPlacemark = MKPlacemark(placemark: topResult)
                        self.annotation.coordinate = (placemark.location?.coordinate)!
                        
                        let annotation = Annotation(title: group.name!, coordinate: (placemark.location?.coordinate)!)
                        
                        //pointAnnotation = CustomPointAnnotation()
                        annotation.pinCustomImageName = "pawpin-40"
                        //pointAnnotation.coordinate = location
                        //pointAnnotation.title = "POKéSTOP"
                        //pointAnnotation.subtitle = "Pick up some Poké Balls"
                        
                        self.pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                        self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
                        //self.mapView.addAnnotation(annotation)
                    }
                })
            }
        }) { (error: Error?) in
            print("error \(String(describing: error?.localizedDescription))")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupCell
        cell.selectionStyle = .none
        cell.group = self.groups[indexPath.row]
        return cell
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        if (annotation is MKUserLocation) {
            return nil
        } else {
        let customPointAnnotation = annotation as! Annotation
        annotationView?.image = UIImage(named: customPointAnnotation.pinCustomImageName)
        
        return annotationView
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "groupDetailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let detailGroupVC = segue.destination as! GroupDetailViewController
                detailGroupVC.group = groups[indexPath.row]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "groupDetailSegue", sender: indexPath.row)
    }


}
