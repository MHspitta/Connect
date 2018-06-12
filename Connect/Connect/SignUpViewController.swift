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
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var SignUp: UIButton!
    @IBOutlet weak var passwordTextCheck: UITextField!
    @IBOutlet weak var succesMessage: UILabel!
    
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
                        // Sign Up succesfull
                        self.succesMessage.text = "You succesfully, signed up!"
                    } else {
                        if let myError = error?.localizedDescription {
                            print(myError)
                        } else {
                            self.succesMessage.text = "ERROR, signup failed!"
                        }
                    }
                })
            } else {
                succesMessage.text = "Password didn't match!"
            }
        }
        clearAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        succesMessage.text = ""
        // Do any additional setup after loading the view.
    }
    
    func clearAll() {
        emailText.text = ""
        passwordTextCheck.text = ""
        passwordText.text = ""
    }
}
