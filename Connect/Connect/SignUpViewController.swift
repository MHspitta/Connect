//
//  SignUpViewController.swift
//  Connect
//
//  Created by Michael Hu on 11-06-18.
//  Copyright © 2018 Michael Hu. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var SignUp: UIButton!
    @IBOutlet weak var passwordTextCheck: UITextField!
    @IBOutlet weak var message: UILabel!
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        message.text = ""
    }
    
    //MARK: - Functions
    
    // Function to create new account
    @IBAction func CreateAccount(_ sender: UIButton) {
        
        // Check for input
        if emailText.text != "" && passwordText.text != "" && passwordTextCheck.text != "" {
            
            // Dubble check password
            if passwordText.text == passwordTextCheck.text {
                
                // Create user to Firebase
                Auth.auth().createUser(withEmail: emailText.text! , password: passwordText.text! , completion: { (user, error) in
                    
                    // Check for errors
                    if user != nil {
                        self.performSegue(withIdentifier: "SignUpSuccesSegue", sender: self)
                    } else {
                        if let myError = error?.localizedDescription {
                            self.message.text = myError
                        } else {
                            self.message.text = "ERROR, signup failed!"
                        }
                    }
                })
            } else {
                message.text = "Password didn't match!"
            }
        }
        clearAll()
    }
    
    // Function to clear the password inputs
    func clearAll() {
        passwordTextCheck.text = ""
        passwordText.text = ""
    }
}
