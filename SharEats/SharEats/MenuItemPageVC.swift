//
//  MenuItemPageVC.swift
//  SharEats
//
//  Created by Toshitaka on 7/7/18.
//  Copyright © 2018 SharEats. All rights reserved.
//

import UIKit

class MenuItemPageVC: UIViewController {

    var item:MenuItem!
    @IBOutlet var menuItemName: UILabel!
    @IBOutlet var menuItemDesc: UILabel!
    @IBOutlet var menuPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        menuItemName.text = item.title
        menuItemDesc.text = item.description
        menuPrice.text = "$" + String(item.price)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func orderPressed(_ sender: Any) {
        //API call to send order
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
