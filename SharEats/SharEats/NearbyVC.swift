//
//  NearbyVC.swift
//  SharEats
//
//  Created by Toshitaka on 5/15/18.
//  Copyright © 2018 SharEats. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON

class NearbyVC: UIViewController,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var listView: UITableView!
    @IBOutlet weak var viewControl: UISegmentedControl!
    var restaurants:[Restaurant]!
    var locationManager:CLLocationManager!
    var currIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listView.delegate = self
        listView.dataSource = self
        mapView.delegate = self
        currIndex = -1
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currIndex = indexPath.row
        performSegue(withIdentifier: "showMenu", sender: view)
    }
    
    /*
     * Helper Functions
     */
    func getRestaurant(loc: CLLocation) -> [Restaurant] {
        var data = [Restaurant]()
        let url = "https://www.shareatpay.com/map/findclosest?latitude=" + String(loc.coordinate.latitude) + "&longitude=" + String(loc.coordinate.latitude)
        
        let json:JSON = HelperFunctions.requestJson(url: url, method: "GET")
        
        for i in json.arrayValue {
            let lat = HelperFunctions.radiansToDegress(radians: i["location"]["latitude"].double!)
            let long = HelperFunctions.radiansToDegress(radians: i["location"]["longitude"].double!)
            let coor:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let temp = Restaurant(coor: coor, name: i["name"].stringValue,id: i["_id"].stringValue)
            data.append(temp)
        }
        
        return data
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 200, 200)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        performSegue(withIdentifier: "showMenu", sender: view)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let check = (sender is MKAnnotation ? true : false)
        if (segue.identifier == "showMenu" && check)
        {
            let avc:MenuVC = segue.destination as! MenuVC
            let view = sender as! MKAnnotationView
            avc.restaurant = view.annotation as! Restaurant
        }
        else {
            let avc:MenuVC = segue.destination as! MenuVC
            avc.restaurant = restaurants[currIndex]
        }
    }
}
