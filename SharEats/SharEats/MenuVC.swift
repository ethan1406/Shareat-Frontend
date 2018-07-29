//
//  MenuVC.swift
//  SharEats
//
//  Created by Toshitaka on 6/16/18.
//  Copyright © 2018 SharEats. All rights reserved.
//

import UIKit

class MenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
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
    var selectedItem:MenuItem!
    
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
        
        menuTable.delegate = self
        menuTable.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reservePressed(_ sender: Any) {
        let alert = UIAlertController(title: "Table Number", message: "Please enter your table number", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textField) in
            textField.text = ""
            textField.keyboardType = .numberPad
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            let textField = alert.textFields![0]
            switch action.style{
            case .default:
                let url = "https://www.shareatpay.com/party/"+self.restaurant!.id+"/"+textField.text!
                print(url)
                let json = HelperFunctions.requestJson(url: url, method:"POST")
                print(json)
                UserDefaults.standard.set(json["partyId"].stringValue,forKey: "partyId")
            case .cancel:
                return
                
            case .destructive:
                print("destructive")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    //set up delegate for table and start displaying menu
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (menu[sections[section]]?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as! MenuItemCell
        cell.title.text = menu[sections[indexPath.section]]![indexPath.row].title
        cell.price.text = "$" + String(menu[sections[indexPath.section]]![indexPath.row].price)
        
//        if let url = NSURL(string: menu[sections[indexPath.section]]![indexPath.row].pictureUrl) {
//            print(url)
//            if let data = NSData(contentsOf: url as URL) {
//                cell.picture.image = UIImage(data: data as Data)
//            }
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = menu[sections[indexPath.section]]![indexPath.row]
        performSegue(withIdentifier: "showItem", sender: view)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showItem" {
            let avc:MenuItemPageVC = segue.destination as! MenuItemPageVC
            avc.item = selectedItem
        }
    }
}
