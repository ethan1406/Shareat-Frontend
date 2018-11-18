//
//  SignUpVC.swift
//  SharEats
//
//  Created by Toshitaka on 7/6/18.
//  Copyright © 2018 SharEats. All rights reserved.
//

import UIKit
import Alamofire

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
        
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        errorLabel.isHidden = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func signupPressed(_ sender: UIButton) {
        guard !firstNameField.text!.isEmpty else {
            errorLabel.isHidden = false
            errorLabel.text = "Please enter your first name"
            return
        }
        
        guard !lastNameField.text!.isEmpty else {
            errorLabel.isHidden = false
            errorLabel.text = "Please enter your last name"
            return
        }
        
        guard !passwordField.text!.isEmpty else {
            errorLabel.isHidden = false
            errorLabel.text = "Please enter your password"
            return
        }
        
        guard passwordField.text! == confirmField.text! else {
            errorLabel.isHidden = false
            errorLabel.text = "Passwords do not match"
            return
        }
        
        signUpUser(){(user, error) in
            guard error == nil else {
                self.errorLabel.isHidden = false
                self.errorLabel.text = error
                return
            }
            
            UserDefaults.standard.set(user!.email, forKey: "email")
            UserDefaults.standard.set(user!.userId, forKey: "userId")
            
            let storyboard = UIStoryboard(name: "Search", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Search") as UIViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func signUpUser(completion: @escaping (User?,String?)->Void) {
        let baseURLString = "https://www.shareatpay.com/signup"
        guard
            !baseURLString.isEmpty,
            let url = URL(string: baseURLString) else {
                return
        }
        
        let parameters: [String: Any] = [
            "email": emailField.text!,
            "password": passwordField.text!,
            "firstName": firstNameField.text!,
            "lastName": lastNameField.text!
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            
            guard let json = response.result.value as? [String: Any] else {
                completion(nil, nil)
                return
            }
            
            if(response.response?.statusCode == 200) {
                guard let email = json["email"] as? String,
                let userId = json["id"] as? String,
                let firstName = json["firstName"] as? String,
                let lastName = json["lastName"] as? String
                    else{
                    completion(nil, nil)
                    return
                }
                completion(User(email: email, userId: userId, firstName: firstName, lastName: lastName), nil)
                
            } else {
                guard let errorMessage = json["error"] as? String else {
                    completion(nil, nil)
                    return
                }
                completion(nil, errorMessage)
            }
        }
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            //            if self.view.frame.origin.y != 0{
            self.view.frame.origin.y = 0
            //            }
        }
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
