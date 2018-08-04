//
//  PaymentVC.swift
//  SharEats
//
//  Created by Toshitaka on 7/30/18.
//  Copyright © 2018 SharEats. All rights reserved.
//

import UIKit
import Stripe

class PaymentVC: UIViewController, STPPaymentMethodsViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        //            let customerContext = MockCustomerContext() //need to create own customer context
        let customerContext = STPCustomerContext(keyProvider: StripeAPIClient.sharedClient)
        
        let paymentContext: STPPaymentContext = STPPaymentContext(customerContext: customerContext)
        paymentContext.paymentAmount = 10
        paymentContext.paymentCurrency = "usd"
//        let theme = STPTheme.default()
//        let config = STPPaymentConfiguration.shared()
//        config.additionalPaymentMethods = .all
//        config.requiredBillingAddressFields = .none
        paymentContext.hostViewController = self
        paymentContext.presentPaymentMethodsViewController()
        
        //            let theme = STPTheme.default()
        //            let config = STPPaymentConfiguration.shared()
        //            config.additionalPaymentMethods = .all
        //            config.requiredBillingAddressFields = .none
        //            let viewController = STPPaymentMethodsViewController(configuration: config,
        //                                                                 theme: theme,
        //                                                                 customerContext: customerContext,
        //                                                                 delegate: self)
        //            let navigationController = UINavigationController(rootViewController: viewController)
        //            navigationController.navigationBar.stp_theme = theme
        //            present(navigationController, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func paymentMethodsViewControllerDidCancel(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func paymentMethodsViewControllerDidFinish(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
        paymentMethodsViewController.navigationController?.popViewController(animated: true)
    }
    
    func paymentMethodsViewController(_ paymentMethodsViewController: STPPaymentMethodsViewController, didFailToLoadWithError error: Error) {
        dismiss(animated: true, completion: nil)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext,
                        didFinishWithStatus status: STPPaymentStatus,
                        error: Error?) {
        
        switch status {
        case .error:
//            self.showError(error)
            return
        case .success:
//            self.showReceipt()
            return
        case .userCancellation:
            return // Do nothing
        }
    }
}
