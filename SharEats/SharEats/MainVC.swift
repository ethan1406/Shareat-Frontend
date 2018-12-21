//
//  MainVC.swift
//  SharEats
//
//  Created by Toshitaka on 4/19/18.
//  Copyright © 2018 SharEats. All rights reserved.
//

import UIKit
import Alamofire

class MainVC: UIViewController {

    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var errorField: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userField.setBottomBorder()
        passwordField.setBottomBorder()
        
        errorField.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(MainVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        errorField.isHidden = true
        //clearing userdefaults
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
        //DELETE LATER
        userField.text = "ethan3@gmail.com"
        passwordField.text = "haha12345"
    }

    @IBAction func goBack(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
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

        fetchUser(){(user, error) in
            guard error == nil else {
                self.errorField.isHidden = false
                self.errorField.text = error
                return
            }
            UserDefaults.standard.set(user!.email, forKey: "email")
            UserDefaults.standard.set(user!.userId, forKey: "userId")
            UserDefaults.standard.set(user!.firstName, forKey: "firstName")
            UserDefaults.standard.set(user!.lastName, forKey: "lastName")
            
            let storyboard = UIStoryboard(name: "Search", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Search") as UIViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func fetchUser(completion: @escaping (User?,String?)->Void) {
        let baseURLString = "https://www.shareatpay.com/login"
        guard
            !baseURLString.isEmpty,
            let url = URL(string: baseURLString) else {
                return
        }
        
        let parameters: [String: Any] = [
            "email": userField.text!,
            "password": passwordField.text!
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
