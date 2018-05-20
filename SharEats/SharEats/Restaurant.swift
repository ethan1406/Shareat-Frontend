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
    
    init(coor: CLLocationCoordinate2D,name: String,addr: String) {
        self.coordinate = coor
        self.name = name
        self.address = addr
    }
    
    var subtitle: String? {
        return name
    }
}
