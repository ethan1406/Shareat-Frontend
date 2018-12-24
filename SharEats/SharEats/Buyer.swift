//
//  Buyer.swift
//  SharEats
//
//  Created by Ethan's Badass Penguin on 12/24/18.
//  Copyright © 2018 SharEats. All rights reserved.
//

import Foundation
import UIKit


class Buyer {
    var firstName: String
    var lastName: String
    var userId: String
    var nameLabel: UILabel?
    
    init(firstName: String, lastName: String, userId: String, nameLabel: UILabel?) {
        self.firstName = firstName
        self.lastName = lastName
        self.userId = userId
        self.nameLabel = nameLabel
    }
}
