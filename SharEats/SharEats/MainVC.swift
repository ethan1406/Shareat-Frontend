//
//  MainVC.swift
//  SharEats
//
//  Created by Toshitaka on 4/19/18.
//  Copyright © 2018 SharEats. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var errorField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorField.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(MainVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //clearing userdefaults
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
        
        //DELETE LATER
        userField.text = "shuzawa@usc.edu"
        passwordField.text = "q1234567"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LoginPressed(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "TabBar") as UIViewController
//        present(vc, animated: true, completion: nil)
        //delete above later
        
        errorField.isHidden = true

        let url = "https://www.shareatpay.com/login?email="+userField.text!+"&password="+passwordField.text!
        print(url)
        let json = HelperFunctions.requestJson(url: url, method: "POST")
        
        print(json["status"].intValue)
        if json["status"].intValue == 0 {
            UserDefaults.standard.set(userField.text,forKey: "username")
            
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TabBar") as UIViewController
            present(vc, animated: true, completion: nil)
        }
        else {
            errorField.text = json["message"].stringValue
            errorField.isHidden = false
        }
    }

    @IBAction func signupPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "signupSegue", sender: self)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
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
