//
//  LoginViewController.swift
//  Connect
//
//  Created by Michael Hu on 11-06-18.
//  Copyright © 2018 Michael Hu. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBAction func login(_ sender: UIButton) {
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text! , password: passwordText.text!) { (user, error) in
                
                if user != nil {
                    // Sign in succesfull
                } else {
                    if let myError = error?.localizedDescription {
                        print(myError)
                    } else {
                        print("ERROR, login failed!")
                    }
                }
            
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
