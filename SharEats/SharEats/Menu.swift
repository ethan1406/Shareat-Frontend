//
//  Menu.swift
//  SharEats
//
//  Created by Toshitaka on 7/6/18.
//  Copyright © 2018 SharEats. All rights reserved.
//

import Foundation
import SwiftyJSON

class MenuItem {
    var title:String
    var price:Double
    var description:String
    var pictureUrl:String
    var id:String
    
    init(title: String, price: Double, desc: String, pic: String, id: String) {
        self.title = title
        self.price = price
        self.description = desc
        self.pictureUrl = pic
        self.id = id
    }
    
    static func toArray(start: [JSON]) -> [MenuItem] {
        var ret:[MenuItem] = []
        
        for i in start {
            let price:String = i["price"].stringValue
            let temp = MenuItem(title: i["title"].stringValue, price: Double(price)!, desc: i["description"].stringValue, pic: i["picture"].stringValue, id: i["id"].stringValue)
            
            print("title:" + i["title"].stringValue)
            ret.append(temp)
        }
        
        return ret
    }
}
