//
//  NearbyVC.swift
//  SharEats
//
//  Created by Toshitaka on 5/15/18.
//  Copyright © 2018 SharEats. All rights reserved.
//

import UIKit
import MapKit

class NearbyVC: UIViewController,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var listView: UITableView!
    @IBOutlet weak var viewControl: UISegmentedControl!
    var restaurants:[Restaurant]!
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listView.delegate = self
        listView.dataSource = self
        
        if viewControl.selectedSegmentIndex == 0 {
            listView.isHidden = true
            mapView.isHidden = false
        }
        else {
            listView.isHidden = false
            mapView.isHidden = true
        }
        
        //setting up map view
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        let currCoordinate = self.locationManager.location?.coordinate
        let currLocation = CLLocation(latitude: currCoordinate!.latitude, longitude: currCoordinate!.longitude)
        centerMapOnLocation(location: currLocation)
        
        //collecting nearby restaurants
        restaurants = getRestaurant(loc: currLocation)
        
        for i in restaurants {
            mapView.addAnnotation(i)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     * Event function
     */
    @IBAction func viewControlChanged(_ sender: Any) {
        if viewControl.selectedSegmentIndex == 0 {
            listView.isHidden = true
            mapView.isHidden = false
        }
        else {
            listView.isHidden = false
            mapView.isHidden = true
        }
    }
    
    
    /*
     * Table View delegate/data source functions
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        cell.textLabel!.text = restaurants[indexPath.row].name
        cell.detailTextLabel!.text = restaurants[indexPath.row].address
        
        return cell
    }
    
    /*
     * Helper Functions
     */
    func getRestaurant(loc: CLLocation) -> [Restaurant] {
        var data = [Restaurant]()
        
        //temp
        let tempCoor = CLLocationCoordinate2D(latitude: loc.coordinate.latitude + 0.002, longitude: loc.coordinate.longitude + 0.002)
        let temp = Restaurant(coor: tempCoor, name: "Temporary", addr: "temporary restaurant")
        data.append(temp)
        
        return data
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 200, 200)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
