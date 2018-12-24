//
//  Order.swift
//  SharEats
//
//  Created by Ethan's Badass Penguin on 10/28/18.
//  Copyright © 2018 SharEats. All rights reserved.
//

import Foundation


class Order {
    
    
    var name: String
    var price: Int
    var buyers: [Buyer]?
    var orderId: String
    
    init(name: String, price: Int, buyers: [Buyer]?, orderId: String) {
        self.name = name
        self.price = price
        self.buyers = buyers
        self.orderId = orderId
    }
}
