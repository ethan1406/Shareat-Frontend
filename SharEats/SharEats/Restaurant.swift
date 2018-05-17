//
//  Restaurant.swift
//  SharEats
//
//  Created by Toshitaka on 5/15/18.
//  Copyright © 2018 SharEats. All rights reserved.
//

import Foundation

class Restaurant {
    var loc:Location
    var name:String
    var address:String
    
    init(long: Double, lat: Double,name: String,addr: String) {
        self.loc = Location(long: long,lat: lat)
        self.name = name
        self.address = addr
    }
}

class Location {
    var longitude:Double
    var latitude:Double
    
    init(long: Double, lat: Double) {
        self.longitude = long
        self.latitude = lat
    }
}
