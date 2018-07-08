//
//  MenuVC.swift
//  SharEats
//
//  Created by Toshitaka on 6/16/18.
//  Copyright © 2018 SharEats. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {
    @IBOutlet weak var reserveButton: UIButton!
    @IBOutlet weak var menuTable: UITableView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var menu:[String:[MenuItem]]!
    var sections:[String]!
    var restaurant:Restaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menu  = [:]
        sections = []
        nameLabel.text = restaurant?.name
        let id = restaurant!.id
        let url = "https://www.shareatpay.com/menu/"+id
        print(url)
        let json = HelperFunctions.requestJson(url: url, method: "GET")
        for (section,items) in json["menu"] {
            menu[section] = MenuItem.toArray(start: items.array!)
            sections.append(section)
        }
        sections.sort()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reservePressed(_ sender: Any) {
        let url = "https://www.shareatpay.com/party/"+restaurant!.id+"/" //+"table number?"
        let json = HelperFunctions.requestJson(url: url, method:"POST")
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    //set up delegate for table and start displaying menu

}
