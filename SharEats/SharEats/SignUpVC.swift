//
//  SignUpVC.swift
//  SharEats
//
//  Created by Toshitaka on 7/6/18.
//  Copyright © 2018 SharEats. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstNameField.setBottomBorder()
        lastNameField.setBottomBorder()
        emailField.setBottomBorder()
        passwordField.setBottomBorder()
        confirmField.setBottomBorder()
        
        errorLabel.isHidden = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signupPressed(_ sender: Any) {
        
        if passwordField.text == confirmField.text {
            let url = "https://www.shareatpay.com/signup?email="+emailField.text!+"&password="+passwordField.text!
            let json = HelperFunctions.requestJson(url: url, method: "POST")
            
            print(json["status"].intValue)
            if json["status"].intValue == 0 {
                dismiss(animated: true, completion: nil)
            }
            else {
                errorLabel.text = json["message"].stringValue
                errorLabel.isHidden = false
            }
        }
        else {
            errorLabel.text = "Passwords do not match"
            errorLabel.isHidden = false
        }
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        
        if let placeholder = self.placeholder {
            self.attributedPlaceholder = NSAttributedString(string:placeholder,
                         attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        }
    }
}
