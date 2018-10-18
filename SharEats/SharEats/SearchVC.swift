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
import SideMenu
//UITableViewDataSource,UITableViewDelegate,
class SearchVC: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var qrCode: UIButton!
    
    var listSelected:Bool!
    //@IBOutlet weak var listView: UITableView!
    //@IBOutlet weak var viewControl: UISegmentedControl!
    var restaurants:[Restaurant]!
    var locationManager:CLLocationManager!
    var currIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuAnimationFadeStrength = 0.5

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let searchBarFont = UIFont.systemFont(ofSize: 17.0)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = searchBarFont
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes[NSAttributedStringKey.font.rawValue] = searchBarFont
        
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes[NSAttributedStringKey.foregroundColor.rawValue] = UIColor.red

        self.searchBar.delegate = self
//        searchBar.isTranslucent = true
//        searchBar.alpha = 1
        searchBar.layer.shadowColor = UIColor.black.cgColor
        searchBar.layer.shadowOffset = CGSize(width: 1, height: 1)
        searchBar.layer.shadowOpacity = 1
        searchBar.layer.shadowRadius = 1.0
        searchBar.clipsToBounds = false
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.searchTextPositionAdjustment = UIOffsetMake(10.0, 0.0);
//        self.searchBar.barTintColor = UIColor.clear
//        let image = self.getImageWithColor(color: UIColor.white, size: CGSize(width: 50, height: 50))
//        searchBar.setSearchFieldBackgroundImage(image, for: .normal)


//        listView.delegate = self
//        listView.dataSource = self
//        mapView.delegate = self
//        listSelected = true
//
//        listView.isHidden = false
        mapView.isHidden = false
        mapView.showsCompass = false;

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
    
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: CGSize(width: size.width, height: size.height))
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 5.0)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        path.fill()
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     * Table View delegate/data source functions
     */
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return restaurants.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
//        cell.textLabel!.text = restaurants[indexPath.row].name
//        cell.detailTextLabel!.text = restaurants[indexPath.row].address
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        currIndex = indexPath.row
//        performSegue(withIdentifier: "showMenu", sender: view)
//    }

    /*
     * Helper Functions
     */
    @IBAction func mapOrSearch(_ sender: UIButton) {
//        if(listSelected){
//            mapButton.setImage(#imageLiteral(resourceName: "List"), for: .normal)
//            listView.isHidden = true
//            mapView.isHidden = false
//            listSelected = false;
//            searchBar.resignFirstResponder()
//            self.view.endEditing(true)
//
//        } else {
//            mapButton.setImage(#imageLiteral(resourceName: "Map"), for: .normal)
//            listView.isHidden = false
//            mapView.isHidden = true
//            listSelected = true;
//        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//        mapButton.setImage(#imageLiteral(resourceName: "Map"), for: .normal)
//        listView.isHidden = false
//        mapView.isHidden = true
//        listSelected = true;
        return true
    }

    
    func getRestaurant(loc: CLLocation) -> [Restaurant] {
        var data = [Restaurant]()
        let url = "https://www.shareatpay.com/map/findclosest?latitude=" + String(loc.coordinate.latitude) + "&longitude=" + String(loc.coordinate.latitude)
        
        let json:JSON = HelperFunctions.requestJson(url: url, method: "GET")
        
        for i in json.arrayValue {
            let lat = HelperFunctions.radiansToDegress(radians: i["location"]["latitude"].double!)
            let long = HelperFunctions.radiansToDegress(radians: i["location"]["longitude"].double!)
            let coor:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let temp = Restaurant(coor: coor, name: i["name"].stringValue, id: i["_id"].stringValue)
            data.append(temp)
        }
        
        return data
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        performSegue(withIdentifier: "showMenu", sender: view)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let check = (sender is MKAnnotation ? true : false)
//        if (segue.identifier == "showMenu" && check)
//        {
//            let avc:MenuVC = segue.destination as! MenuVC
//            let view = sender as! MKAnnotationView
//            avc.restaurant = view.annotation as! Restaurant
//        }
//        else {
//            let avc:MenuVC = segue.destination as! MenuVC
//            avc.restaurant = restaurants[currIndex]
//        }
//    }

    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}
