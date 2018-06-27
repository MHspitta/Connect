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
    
    //MARK: - Outlets
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    //MARK: - Functions
    
    // Function to login
    @IBAction func login(_ sender: UIButton) {
        
        // Check input
        if emailText.text != "" && passwordText.text != "" {
            
            // Login
            Auth.auth().signIn(withEmail: emailText.text! , password: passwordText.text!) { (user, error) in
                
                // Check if input is correct else error message
                if user != nil {
                    self.performSegue(withIdentifier: "loginSuccesSegue", sender: self)
                } else {
                    if let myError = error?.localizedDescription {
                        self.errorLabel.text = myError
                    } else {
                        self.errorLabel.text = "ERROR, login failed!"
                    }
                }
            
            }
        }
    }
    
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {
        
    }
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        errorLabel.text = ""
    }

}
