//
//  Restaurants.swift
//  SharEats
//
//  Created by Ethan's Badass Penguin on 9/3/18.
//  Copyright © 2018 SharEats. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SwiftyJSON
import Alamofire
import AlamofireImage

class RestaurantsVC: UIViewController,UITableViewDataSource,CLLocationManagerDelegate,UITableViewDelegate {
     
    @IBOutlet weak var listView: UITableView!
    var restaurants:[Restaurant]!
    var locationManager:CLLocationManager!
    var currIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listView.delegate = self
        listView.dataSource = self
        listView.rowHeight = 230

        //collecting nearby restaurants
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        let currCoordinate = self.locationManager.location?.coordinate
        let currLocation = CLLocation(latitude: currCoordinate!.latitude, longitude: currCoordinate!.longitude)
        restaurants = getRestaurant(loc: currLocation)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantTableViewCell", for: indexPath) as! RestaurantTableViewCell
        cell.title.text = restaurants[indexPath.row].name
        cell.address.text = restaurants[indexPath.row].address
        if let urlString = restaurants[indexPath.row].profilePicURL {
            Alamofire.request(urlString).responseImage { response in
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    DispatchQueue.main.async {
                        if let currentIndexPath =
                            tableView.indexPath(for: cell),
                            currentIndexPath != indexPath {
                            return
                        }
                        cell.profilePic.image = image
                    }
                }
            }
        }
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
            //profile pic url
            var profilePicURL: String? = nil
            let profilePicJson = i["profilepic"]
            if(profilePicJson != JSON.null) {
                profilePicURL = profilePicJson.stringValue
                if(profilePicURL == "") {
                    profilePicURL = nil
                }
            }
            //address
            var address: String = "None Provided"
            let addressJson = i["address"]
            if(addressJson != JSON.null) {
                address = addressJson.stringValue
            }
            let temp = Restaurant(coor: coor, name: i["name"].stringValue,id: i["_id"].stringValue, profilePicURL: profilePicURL, addr: address)
            data.append(temp)
        }
        
        return data
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

