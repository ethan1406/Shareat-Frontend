//
//  ConfirmationViewController.swift
//  Shareat
//
//  Created by Ethan's Badass Penguin on 1/8/19.
//  Copyright © 2019 SharEats. All rights reserved.
//

import UIKit

class ConfirmationViewController: UINavigationController, UITableViewDataSource, UITableViewDelegate {

    var myOrders: [Order]?
    
    var totalPrice: Int?
    var restaurantName: String?
    
    @IBOutlet weak var myOrderList: UITableView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        subtotalLabel.text = priceToDisplay(price: totalPrice!)
        restaurantNameLabel.text = restaurantName!
        
        let tax = Int(Double(totalPrice!) * 0.095)
        taxLabel.text = priceToDisplay(price: tax)
        
        let tip = Int(Double(totalPrice!) * 0.10)
        tipLabel.text = priceToDisplay(price: tip)
        
        let total = tax + tip + totalPrice!
        totalPriceLabel.text = priceToDisplay(price: total)
        
        
        myOrderList.delegate = self
        myOrderList.dataSource = self
        myOrderList.register(CheckTableViewCell.self, forCellReuseIdentifier: "CheckTableViewCell2")
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckTableViewCell2", for: indexPath) as! CheckTableViewCell
        cell.dishName = myOrders![indexPath.row].name
        cell.price = myOrders![indexPath.row].price
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myOrders!.count
    }

    func priceToDisplay(price: Int) -> String {
        let priceDecimal: Double = Double(price)/100
        return "$" + String(priceDecimal)
    }
}
