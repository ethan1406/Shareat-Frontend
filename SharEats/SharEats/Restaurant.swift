//
//  Restaurant.swift
//  SharEats
//
//  Created by Toshitaka on 5/15/18.
//  Copyright © 2018 SharEats. All rights reserved.
//

import Foundation
import MapKit

class Restaurant: NSObject, MKAnnotation {
    var name:String
    var address:String
    let coordinate: CLLocationCoordinate2D
    var menu:[String:[String]]
    var id:String
    var identifier = "restaurant"
    
    init(coor: CLLocationCoordinate2D,name: String,id: String,addr: String = "None provided",menu: [String:[String]] = ["error":["No menu provided"]]) {
        self.coordinate = coor
        self.name = name
        self.address = addr
        self.menu = menu
        self.id = id
    }
    
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return id
    }
}
