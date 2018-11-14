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
    
    
    var orders: [Order]?
    var partyId: String?
    var buttonBar: UIView!
    
    
    //used to detect double tap
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
        
        orderList.delegate = self
        orderList.dataSource = self
        orderList.alwaysBounceVertical = false
        orderList.estimatedRowHeight = 44
        orderList.rowHeight = UITableViewAutomaticDimension
        
        buttonBar = UIView()
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = UIColor.orange
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
            NSAttributedStringKey.foregroundColor: UIColor.orange
            ], for: .selected)
        
        groupOrIndividual.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: UIControlEvents.valueChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // subscribe to channel and bind to event
        let channel = pusher.subscribe(partyId!)
        
        let _ = channel.bind(eventName: "splitting", callback: { (data: Any?) -> Void in
            if let data = data as? [String : AnyObject] {
                guard let orderId = data["orderId"] as? String, let name = data["name"] as? String else {
                    return
                }

                var row: Int = -1
                for (index, element) in self.orders!.enumerated() {
                    if element.orderId == orderId {
                        row = index
                    }
                }
                self.addNameToCell(atIndex: row, addName: name, backgroundColor: .black)
                
            }
        })
        
        pusher.connect()

    }
    
    func addNameToCell(atIndex index: Int, addName name: String, backgroundColor: UIColor = .clear) {
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = orderList.cellForRow(at: indexPath) {
            cell.backgroundColor = backgroundColor
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckTableViewCell", for: indexPath) as! CheckTableViewCell
        cell.dishName.text = orders![indexPath.row].name
        cell.selectionStyle = .none
        
        guard let customers = orders![indexPath.row].buyers else {
            return cell
        }

        for (index, element) in customers.enumerated() {
            let name = createSharedDishCustomer("EC", at: index, parentView: cell.sharedByView.bounds)
            cell.sharedByView.addSubview(name)
        }

        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let now: TimeInterval = Date().timeIntervalSince1970
        if (now - lastClick < 0.3) && (lastIndexPath?.row == indexPath.row )
        {
            var isBuyer: Bool = false
            for buyer in orders![indexPath.row].buyers! {
                if buyer["userId"] == UserDefaults.standard.string(forKey: "userId") {
                    isBuyer = true
                    print("yes")
                }
            }
            splitOrder(orders![indexPath.row].orderId)
        }
        lastClick = now
        lastIndexPath = indexPath
    }
    
    func createSharedDishCustomer(_ name: String, at position: Int, parentView parent: CGRect) -> UILabel {
        let name = UILabel(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        name.textAlignment = .center
        name.textColor = .white
        name.text = "EC"
        name.center = CGPoint(x: parent.size.width - 114 - CGFloat(position) * 30, y: parent.size.height/4)
        
        name.layer.cornerRadius = name.frame.width/2
        name.backgroundColor = .orange
        name.layer.masksToBounds = true
        name.adjustsFontSizeToFitWidth = true
        return name
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

