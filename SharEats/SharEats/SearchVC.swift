//
//  searchVC.swift
//  SharEats
//
//  Created by Toshitaka on 5/15/18.
//  Copyright © 2018 SharEats. All rights reserved.
//

import AVFoundation
import QRCodeReader
import UIKit
import MapKit
import SwiftyJSON
import SideMenu
import Alamofire
//UITableViewDataSource,UITableViewDelegate,
class SearchVC: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate, QRCodeReaderViewControllerDelegate {
    
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
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            switch(CLLocationManager.authorizationStatus()) {
            case .authorizedAlways, .authorizedWhenInUse:
                if let location = self.locationManager.location {
                    let currCoordinate = location.coordinate
                    let currLocation = CLLocation(latitude: currCoordinate.latitude, longitude: currCoordinate.longitude)
                    centerMapOnLocation(location: currLocation)
                    //collecting nearby restaurants
                    restaurants = getAllRestaurants()
                    for restaurant in restaurants {
                        mapView.addAnnotation(restaurant)
                    }
                }
            default:
                break;
            }
        }
        
    }
    
    func locationManagerSetUp() -> CLLocationManager?{
        
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        //check if location services are enabled at all
        if CLLocationManager.locationServicesEnabled() {
            print(CLLocationManager.authorizationStatus())
            switch(CLLocationManager.authorizationStatus()) {
            //check if services disallowed for this app particularly
            case .restricted, .denied:
                print("No access")
                let accessAlert = UIAlertController(title: "Location Services Disabled", message: "You need to enable location services in settings.", preferredStyle: UIAlertControllerStyle.alert)
                
                accessAlert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: { (action: UIAlertAction!) in UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString) as! URL)
                }))
                
                present(accessAlert, animated: true, completion: nil)
                return locationManager
                
            //check if services are allowed for this app
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access! We're good to go!")
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                return locationManager
            //check if we need to ask for access
            case .notDetermined:
                print("asking for access...")
                
            }
            //location services are disabled on the device entirely!
        } else {
            print("Location services are not enabled")
            
        }
        return nil
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
    
    func getAllRestaurants() -> [Restaurant] {
        var data = [Restaurant]()
        let url = "https://www.shareatpay.com/map/allRestaurants"
        
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
    
    // Good practice: create the reader lazily to avoid cpu overload during the
    // initialization and each time we need to scan a QRCode
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    
    @IBAction func scanAction(_ sender: Any) {
        // Retrieve the QRCode content
        // By using the delegate pattern
        readerVC.delegate = self
        
        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
        
        let baseURLString = "https://www.shareatpay.com/party/5b346f48d585fb0e7d3ed3fc/6"
        guard
            !baseURLString.isEmpty,
            let url = URL(string: baseURLString) else {
                return
        }
        
    }
    
    
    // MARK: - QRCodeReaderViewController Delegate Methods
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
        if(result.value.prefix(33) != "https://www.shareatpay.com/party/"){
            let tableNotFoundAlert = UIAlertController(title: "Table Not Found", message: "This is not a valid Shareat QR code", preferredStyle: UIAlertControllerStyle.alert)
            
            tableNotFoundAlert.addAction(UIAlertAction(title: NSLocalizedString("OK!", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            
            self.present(tableNotFoundAlert, animated: true, completion: nil)
        } else {
            Alamofire.request(result.value, method: .get).responseJSON { (response) in
                if(response.response?.statusCode == 200) {
                    guard let json = response.result.value as? [String: Any] else {
                        return
                    }
                    let storyboard = UIStoryboard(name: "Search", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "Check") as! CheckViewController
                    var orders = [Order]()
                    var myOrders = [Order]()
                    
                    for order in json["orders"] as! [[String : Any]] {
                        let id = order["_id"] as! String
                        let dishName = order["name"] as! String
                        let price = order["price"] as! Int
                        if order["buyers"] == nil {
                            orders.append(Order(name: dishName, price: price, buyers: nil, orderId: id))
                        } else {
                            var buyers = [Buyer]()
                            var isMyOrder = false
                            for buyer in order["buyers"] as! [[String : Any]] {
                                let firstName = buyer["firstName"] as! String,
                                lastName = buyer["lastName"] as! String,
                                userId = buyer["userId"] as! String
                                if(userId ==  UserDefaults.standard.string(forKey: "userId")) {
                                    isMyOrder = true
                                }
                                buyers.append(Buyer(firstName:
                                    firstName,lastName: lastName, userId: userId, nameLabel: nil))
                            }
                            orders.append(Order(name: dishName, price: price, buyers: buyers, orderId: id))
                            if(isMyOrder) {
                                myOrders.append(Order(name: dishName, price: price, buyers: buyers, orderId: id))
                            }
                        }
                    }
                    
                    let party_id = json["_id"] as! String
                    let totalPrice = json["orderTotal"] as! Int
                    let restaurantName = json["restaurantName"] as! String
                    
                    vc.totalPrice = totalPrice
                    vc.orders = orders
                    vc.restaurantName = restaurantName
                    vc.myOrders = myOrders
                    vc.partyId = party_id
                    self.present(vc, animated: true, completion: nil)
                    
                    
                } else if(response.response?.statusCode == 404){
                    
                    let tableNotFoundAlert = UIAlertController(title: "Table Not Found", message: "This table has not been established at the restaurant", preferredStyle: UIAlertControllerStyle.alert)
                    
                    tableNotFoundAlert.addAction(UIAlertAction(title: NSLocalizedString("OK!", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                    }))
                    
                    self.present(tableNotFoundAlert, animated: true, completion: nil)
                    return
                }
                
            }
            
        }
    }
    
    //This is an optional delegate method, that allows you to be notified when the user switches the cameraName
    //By pressing on the switch camera button
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        let cameraName = newCaptureDevice.device.localizedName
        print("Switching capturing to: \(cameraName)")
        
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}
