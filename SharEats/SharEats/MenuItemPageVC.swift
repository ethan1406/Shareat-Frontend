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
    @IBOutlet var orderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuItemName.text = item.title
        menuItemDesc.text = item.description
        menuPrice.text = "$" + String(item.price)

        let partyId:String? = UserDefaults.standard.object(forKey: "partyId") as? String ?? nil
        if partyId == nil {
            orderButton.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func orderPressed(_ sender: Any) {
        let partyId:String? = UserDefaults.standard.object(forKey: "partyId") as? String ?? nil
        let url = "https://www.shareatpay.com/order/" + partyId! + "/" + item.id
        print(url)
        _ = HelperFunctions.requestJson(url: url, method: "POST")
        
        let alert = UIAlertController(title: "Success", message: "You have ordered 1 " + item.title + " successfully", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                return
            case .cancel:
                return
            case .destructive:
                return
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
