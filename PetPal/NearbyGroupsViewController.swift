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
import Parse
import ParseUI

class NearbyGroupsViewController: UIViewController,  MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    let annotation = MKPointAnnotation()
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    //var pinAnnotationView:MKPinAnnotationView!
    
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
        mapView.showsUserLocation = true
        loadGroups()
        addPinsForGroups()
        // register tableView Cell
        let nibName = UINib(nibName: "GroupCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "GroupCell")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lookUpCurrentLocation()
    }
    //set region
    
    func lookUpCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation: CLLocation = locations[0] as CLLocation
        let viewRegion = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 40000, 40000)
        mapView.setRegion(viewRegion, animated: false)
        
    }
    
    func addAnnotationFromAddress (group: Group) -> Void {
        if let address = group.location {
            //print("current address")
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?.first
                    let placemark: MKPlacemark = MKPlacemark(placemark: firstLocation!)
                    self.annotation.coordinate = (placemark.location?.coordinate)!
                    let annotation = Annotation(title: group.name!, coordinate: (placemark.location?.coordinate)!)
                    annotation.pinCustomImageName = "pawpin"
                    annotation.group = group
                    let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                    self.mapView.addAnnotation(pinAnnotationView.annotation!)
                } else {
                    print("error \(error?.localizedDescription)")
                }
            })
        }
    }
    
    func loadGroups(){
        PetPalAPIClient.sharedInstance.getGroups(success: { (groups: [Group]) in
            self.groups = groups
            self.tableView.reloadData()
        }) { (error: Error?) in
            print("error \(error?.localizedDescription ?? "Default Error String")")
        }
    }

    func addPinsForGroups(){
        PetPalAPIClient.sharedInstance.getGroups(success: { (goups: [Group]) in
            for group in self.groups {
                self.addAnnotationFromAddress(group: group)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = groups[indexPath.row]
        performSegue(withIdentifier: "groupDetailSegue", sender: group)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
            let imageView = PFImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            //imageView.isUserInteractionEnabled = true
            annotationView?.leftCalloutAccessoryView = imageView
            let imageButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            let image = UIImage(named: "disclosure-48")
            imageButton.setImage(image, for: UIControlState.normal)
            annotationView?.rightCalloutAccessoryView = imageButton
        } else {
            annotationView!.annotation = annotation
        }

        
        if (annotation is MKUserLocation) {
            return nil
        } else {
            let customPointAnnotation = annotation as! Annotation
            annotationView?.image = UIImage(named: customPointAnnotation.pinCustomImageName)
            if let group = customPointAnnotation.group {
                let imageView = annotationView?.leftCalloutAccessoryView as! PFImageView
                imageView.file = group.profileImage
                imageView.loadInBackground()
            }
          return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? Annotation {
            performSegue(withIdentifier: "groupDetailSegue", sender: annotation.group!)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "groupDetailSegue" {
            if let group = sender as? Group {
                let detailGroupVC = segue.destination as! GroupDetailViewController
                detailGroupVC.group = group
            }
        }
    }
}

