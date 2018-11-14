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
    var buyers: [[String:String]]?
    var orderId: String
    
    init(name: String, buyers: [[String:String]]?, orderId: String) {
        self.name = name
        self.buyers = buyers
        self.orderId = orderId
    }
}
