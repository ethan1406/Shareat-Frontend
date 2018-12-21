//
//  Check.swift
//  SharEats
//
//  Created by Ethan's Badass Penguin on 10/27/18.
//  Copyright © 2018 SharEats. All rights reserved.
//

import UIKit
import PusherSwift
import Alamofire


class CheckViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let orange = UIColor(red: 243/255, green: 165/255, blue: 69/255, alpha: 1.0)
    
    var orders: [Order]?
    var myOrders: [Order]?
    var partyId: String?
    var buttonBar: UIView!
    var totalPrice: Int?
    
    var colors: [UIColor]?
    var names: [[UILabel]]?
    
    //used to detect double tap
   
    @IBOutlet weak var totalPriceLabel: UILabel!
    var lastClick: TimeInterval = Date().timeIntervalSince1970
    var lastIndexPath: IndexPath?
    
    @IBOutlet weak var orderList: UITableView!
    @IBOutlet weak var groupOrIndividual: UISegmentedControl!
    
    let pusher = Pusher(
        key: "96771d53b6966f07b9f3",
        options: PusherClientOptions(
            host: .cluster("us2")
        )
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colors = [orange, .red, .purple, .magenta]
        
        names = Array(repeating: Array(repeating: UILabel(), count: 0), count: orders!.count)
        
        orderList.delegate = self
        orderList.dataSource = self
        orderList.alwaysBounceVertical = false
        orderList.register(CheckTableViewCell.self, forCellReuseIdentifier: "CheckTableViewCell2")
        orderList.estimatedRowHeight = 100
        orderList.rowHeight = UITableViewAutomaticDimension
        //orderList.separatorStyle = UITableViewCellSeparatorStyle.none
        orderList.alwaysBounceVertical = false
        orderList.bounces = false
        orderList.showsVerticalScrollIndicator = false
        
        myOrders = [Order]()
        createMyOrdersDataSource()
        
        let priceDecimal: Double = Double(totalPrice!)/100
        let priceDisplay = "$" + String(priceDecimal)

        totalPriceLabel.text = priceDisplay
        
        buttonBar = UIView()
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = orange
        view.addSubview(buttonBar)
        
        // Constrain the top of the button bar to the bottom of the segmented control
        buttonBar.topAnchor.constraint(equalTo: groupOrIndividual.bottomAnchor).isActive = true
        buttonBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
        // Constrain the button bar to the left side of the segmented control
        buttonBar.leftAnchor.constraint(equalTo: groupOrIndividual.leftAnchor).isActive = true
        // Constrain the button bar to the width of the segmented control divided by the number of segments
        buttonBar.widthAnchor.constraint(equalTo: groupOrIndividual.widthAnchor, multiplier: 1 / CGFloat(groupOrIndividual.numberOfSegments)).isActive = true
        
        groupOrIndividual.backgroundColor = .clear
        groupOrIndividual.tintColor = .clear
        
        groupOrIndividual.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18.0),
            NSAttributedStringKey.foregroundColor: UIColor.lightGray
            ], for: .normal)
        
        groupOrIndividual.setTitleTextAttributes([
            NSAttributedStringKey.font :UIFont.systemFont(ofSize: 18.0),
            NSAttributedStringKey.foregroundColor: orange
            ], for: .selected)
        
        groupOrIndividual.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: UIControlEvents.valueChanged)
        
    }
    
    func createMyOrdersDataSource() {
        for order in orders! {
            guard let customers = order.buyers else {
                return
            }
            for (index, element) in customers.enumerated() {
                guard let firstName = element["firstName"], let lastName = element["lastName"], let userId = element["userId"] else {
                    return
                }
                if(userId ==  UserDefaults.standard.string(forKey: "userId")) {
                    myOrders!.append(order)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // subscribe to channel and bind to event
        let channel = pusher.subscribe(partyId!)
        
        let _ = channel.bind(eventName: "splitting", callback: { (data: Any?) -> Void in
            if let data = data as? [String : AnyObject] {
                guard let orderId = data["orderId"] as? String, let
                    isAdd = data["add"] as? Bool, let
                    userId = data["userId"] as? String else {
                    return
                }
                var row: Int = -1
                for (index, element) in self.orders!.enumerated() {
                    if element.orderId == orderId {
                        row = index
                    }
                }
                if(isAdd) {
                    guard let firstName = data["firstName"] as? String, let lastName = data["lastName"] as? String, let colorIndex = data["colorIndex"] as? Int else {
                            return
                    }
                    var acronym = ""
                    acronym.append(firstName[firstName.startIndex])
                    acronym.append(lastName[lastName.startIndex])
                    self.addNameToCell(atIndex: row, addName: acronym, userId: userId, color: self.colors![colorIndex % self.colors!.count])
                } else {
                    self.removeNameFromCell(atIndex: row, userId: userId)
                }
            }
        })
        pusher.connect()
    }
    
    func removeNameFromCell(atIndex index: Int, userId: String) {
        let indexPath = IndexPath(row: index, section: 0)
        
        if let cell = orderList.cellForRow(at: indexPath) as? CheckTableViewCell{
            var indexToRemove = -1
            for (i, element) in orders![index].buyers!.enumerated() {
                guard let id = element["userId"] as? String else {
                    return
                }
                if id == userId {
                    indexToRemove = i
                }
            }
            if (indexToRemove != -1) {
                orders![index].buyers!.remove(at: indexToRemove)
                UIView.animate(withDuration: 0.5, animations: {
                    self.names![index][indexToRemove].alpha = 0.0
                    for (i, name) in self.names![index].enumerated() {
                        if(i > indexToRemove) {
                            name.center.x = name.center.x + 30
                        }
                    }
                })
                names![index].remove(at: indexToRemove)
            }
        }
    }
    
    func addNameToCell(atIndex index: Int, addName name: String, userId: String, color: UIColor = .clear) {
        let indexPath = IndexPath(row: index, section: 0)
        
        if let cell = orderList.cellForRow(at: indexPath) as? CheckTableViewCell{
            var createEllipsis = false
            if names![index].count > 0 {
//                print(names![index][0].frame.minX)
//                print(cell.sharedByView.frame.minX)
                if names![index][names![index].count - 1].frame.minX - 30 < 0 {
                    createEllipsis = true
                }
            }
            
            if !createEllipsis {
                let newName = createSharedDishCustomer(name, at: 0, parentView: cell.sharedByView, color: color, isEllipsis: false)
                newName.alpha = 0.0
                cell.sharedByView.addSubview(newName)
                if orders![index].buyers == nil || orders![index].buyers!.count == 0 {
                    UIView.animate(withDuration: 0.5, animations: {
                        newName.alpha = 1.0
                    })
                } else {
                    UIView.animate(withDuration: 0.5, animations: {
                        for name : UILabel in self.names![index] {
                            name.center.x = name.center.x - 30
                        }
                        newName.alpha = 1.0
                    })
                }
                orders![index].buyers!.insert(["userId": userId], at: 0)
                names![index].insert(newName, at: 0)
            } else {
                let more = createSharedDishCustomer("+1", at: 0, parentView: names![index][names![index].count - 1], color: color, isEllipsis: true)
                more.alpha = 0.0
                cell.sharedByView.addSubview(more)
                UIView.animate(withDuration: 0.5, animations: {
                    more.alpha = 1.0
                })
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pusher.disconnect()
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.3) {
            self.buttonBar.frame.origin.x = (self.groupOrIndividual.frame.width / CGFloat(self.groupOrIndividual.numberOfSegments)) * CGFloat(self.groupOrIndividual.selectedSegmentIndex)
        }
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        orderList.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(groupOrIndividual.selectedSegmentIndex){
        case 0:
            return orders!.count
        case 1:
            return myOrders!.count
        default:
            return orders!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckTableViewCell2", for: indexPath) as! CheckTableViewCell
        
//        for view:UIView in cell.contentView.subviews {
//            view.removeFromSuperview()
//        }
        cell.selectionStyle = .none
        
        switch(groupOrIndividual.selectedSegmentIndex){
        case 0:
            cell.dishName = orders![indexPath.row].name
            cell.price = orders![indexPath.row].price
            
            guard let customers = orders![indexPath.row].buyers else {
                return cell
            }
            
            for (index, element) in customers.enumerated() {
                guard let firstName = element["firstName"], let lastName = element["lastName"] else {
                    return cell
                }
                var acronym = ""
            acronym.append(firstName[firstName.startIndex])
                acronym.append(lastName[lastName.startIndex])
                
                let name = createSharedDishCustomer(acronym, at: index, parentView: cell.sharedByView, color: colors![index % colors!.count], isEllipsis: false)
                cell.sharedByView.addSubview(name)
                names![indexPath.row].append(name)
            }
            break
        case 1:
            cell.dishName = myOrders![indexPath.row].name
            guard let customers = myOrders![indexPath.row].buyers else {
                return cell
            }
            
            for (index, element) in customers.enumerated() {
                guard let firstName = element["firstName"], let lastName = element["lastName"],
                    let userId = element["userId"] else {
                    return cell
                }
                
                var acronym = ""
                acronym.append(firstName[firstName.startIndex])
                acronym.append(lastName[lastName.startIndex])
                
                let name = createSharedDishCustomer(acronym, at: index, parentView: cell.sharedByView, color: colors![index % colors!.count], isEllipsis: false)
                
            }
            
        default:
            break
            
        }
        cell.layoutSubviews()
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let now: TimeInterval = Date().timeIntervalSince1970
        if (now - lastClick < 0.3) && (lastIndexPath?.row == indexPath.row )
        {
            splitOrder(orders![indexPath.row].orderId)
        }
        lastClick = now
        lastIndexPath = indexPath
    }
    
    
    func createSharedDishCustomer(_ name: String, at position: Int, parentView parent: UIView, color: UIColor, isEllipsis more: Bool) -> UILabel {
        let nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        if !more {
            nameLabel.textColor = .white
            nameLabel.backgroundColor = color
            nameLabel.text = name
            nameLabel.center.x = parent.bounds.size.width - 25 - CGFloat(position) * 30
            nameLabel.center.y = parent.center.y
        } else {
            nameLabel.textColor = .black
            nameLabel.backgroundColor = .white
            nameLabel.text = name
            nameLabel.center.x = parent.frame.minX - 30
            nameLabel.center.y = parent.center.y
        }
        
        nameLabel.setDisplayLabel()
        return nameLabel
    }

    
    func splitOrder(_ orderId: String) {
        let baseURLString = "https://www.shareatpay.com/order/split"
        guard
            !baseURLString.isEmpty,
            let url = URL(string: baseURLString) else {
                return
        }
        
        let parameters: [String: Any] = [
            "partyId": partyId!,
            "orderId": orderId
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            if(response.response?.statusCode == 200) {
                guard let json = response.result.value as? [String: Any] else {
                    return
                }
                
            } else if(response.response?.statusCode == 404){
                
                
                return
            }
            
        }
    }
}


extension UILabel {
    func setDisplayLabel() {
        self.textAlignment = .center
        
        self.layer.cornerRadius = self.frame.width/2
        self.layer.masksToBounds = true
        self.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin, .flexibleTopMargin]
        self.adjustsFontSizeToFitWidth = true
    }
}
