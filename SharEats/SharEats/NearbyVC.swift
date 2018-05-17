//
//  NearbyVC.swift
//  SharEats
//
//  Created by Toshitaka on 5/15/18.
//  Copyright © 2018 SharEats. All rights reserved.
//

import UIKit

class NearbyVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var listView: UITableView!
    @IBOutlet weak var viewControl: UISegmentedControl!
    var restaurants:[Restaurant]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listView.delegate = self
        listView.dataSource = self
        
        if viewControl.selectedSegmentIndex == 0 {
            listView.isHidden = true
        }
        else {
            listView.isHidden = false
        }
        
        restaurants = getRestaurant()
        // Do any additional setup after loading the view.
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
        }
        else {
            listView.isHidden = false
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
        cell.detailTextLabel!.text = restaurants[indexPath.row].address + "--" + String(format:"%f",restaurants[indexPath.row].loc.latitude) + String(format:"%f",restaurants[indexPath.row].loc.longitude)
        
        return cell
    }
    
    /*
     * Helper Functions
     */
    func getRestaurant() -> [Restaurant] {
        var data = [Restaurant]()
        
        //temp
        data.append(Restaurant(long: 0.5, lat: 0.5, name: "Temporary", addr: "Temp Addr"))
        
        return data
    }
}
