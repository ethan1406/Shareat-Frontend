//
//  User.swift
//  SharEats
//
//  Created by Ethan's Badass Penguin on 9/11/18.
//  Copyright © 2018 SharEats. All rights reserved.
//

import Foundation

class User {
    
    var email: String
    var userId: String
    var firstName: String
    var lastName: String
    
    init(email: String, userId: String, firstName: String, lastName: String) {
        self.email = email
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
    }
}
