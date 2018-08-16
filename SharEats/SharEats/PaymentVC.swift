//
//  PaymentVC.swift
//  SharEats
//
//  Created by Toshitaka on 7/30/18.
//  Copyright © 2018 SharEats. All rights reserved.
//

import UIKit
import Stripe

class PaymentVC: UIViewController, STPPaymentContextDelegate {

    private let customerContext: STPCustomerContext
    private let paymentContext: STPPaymentContext
    @IBOutlet var priceButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        customerContext = STPCustomerContext(keyProvider: StripeAPIClient.sharedClient)
        paymentContext = STPPaymentContext(customerContext: customerContext)
        paymentContext.paymentCurrency = "usd"

        super.init(coder: aDecoder)
        
        paymentContext.delegate = self
        paymentContext.hostViewController = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let url = ""
        //let json = HelperFunctions.requestJson(url: url, method: "POST")
        let price = 10

        paymentContext.paymentAmount = price
        priceButton.isEnabled = false
        priceButton.setTitle("$" + String(price), for: UIControlState.normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UI event functions
    @IBAction func paymentPressed(_ sender: Any) {
        paymentContext.presentPaymentMethodsViewController()
    }
    
    @IBAction func confirmPressed(_ sender: Any) {
        //if paymentContext is set up correctly, confirm payment
        paymentContext.requestPayment()
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // STPPaymentContext Delegate Functions
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        print("[ERROR]: Unrecognized error while loading payment context (testing): \(error)");
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        // update ui after payment context changed
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        // Create charge using payment result
        
        //StripeAPIClient.completeCharge()...
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        switch status {
        case .success:
            print("success")
        case .error:
            print("error")
        case .userCancellation:
            print("userCancelled")
        }
    }
}
