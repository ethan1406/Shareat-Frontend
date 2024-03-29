//
//  StripeAPIClient.swift
//  SharEats
//
//  Created by Toshitaka on 7/31/18.
//  Copyright © 2018 SharEats. All rights reserved.
//

import Foundation
import Stripe
import Alamofire

class StripeAPIClient: NSObject, STPEphemeralKeyProvider {
    
    static let sharedClient = StripeAPIClient()
    var baseURLString: String? = "https://www.shareatpay.com/customer/me/ephemeral_keys?api_version=2018-07-27"
    var keyURL: URL {
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }
    
    var baseURLString2: String? = "https://www.shareatpay.com/party/charge"
    var chargeURL: URL {
        if let urlString = self.baseURLString2, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }
    
    func completeCharge(_ result: STPPaymentResult,
                        amount: Int,
                        shippingAddress: STPAddress?,
                        shippingMethod: PKShippingMethod?,
                        completion: @escaping STPErrorBlock) {
        let url = self.chargeURL
        var params: [String: Any] = [
            "source": result.source.stripeID,
            "amount": amount
        ]
        params["shipping"] = STPAddress.shippingInfoForCharge(with: shippingAddress, shippingMethod: shippingMethod)
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success:
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
        }
    }
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        //let url = self.baseURL.appendingPathComponent("ephemeral_keys")
        let url = self.keyURL
        Alamofire.request(url, method: .post, parameters: [
            "api_version": apiVersion,
            ])
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
}
