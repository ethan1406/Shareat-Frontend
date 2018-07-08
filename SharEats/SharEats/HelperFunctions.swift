//
//  JsonHelper.swift
//  SharEats
//
//  Created by Toshitaka on 6/24/18.
//  Copyright © 2018 SharEats. All rights reserved.
//

import Foundation
import SwiftyJSON

class HelperFunctions {
    static func requestJson(url: String, method: String) -> JSON{
        var json = JSON.null
        let encodedHost = NSString(format: url as NSString).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let requestUrl = URL(string: encodedHost!)
        var queryFinished = false
        
        let request = NSMutableURLRequest(url: requestUrl!)
        request.httpMethod = method
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
            if error != nil {
                return
            }
            
            json = try! JSON(data: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            queryFinished = true
        }
        task.resume()
        // Blocks until a query is returned from http request
        while queryFinished == false {}
        
        return json
    }
    
    static func degreesToRadians(degrees: Double) -> Double {
        return degrees * Double.pi / 180
    }
    
    static func radiansToDegress(radians: Double) -> Double {
        return radians * 180 / Double.pi
    }
}
