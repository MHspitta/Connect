//
//  CreateActivityViewController.swift
//  Connect
//
//  Created by Michael Hu on 12-06-18.
//  Copyright © 2018 Michael Hu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CreateActivityViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,
    UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var activityName: UITextField!
    @IBOutlet weak var maxParticipants: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var locationActivity: UITextField!
    @IBOutlet weak var descriptionTextfield: UITextView!
    @IBOutlet weak var imagePicker: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: - Variables
    
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    var category: String!
    var userName: String!
    
    // Check which user is logged in
    let uid = Auth.auth().currentUser?.uid

    let categories = ["Sports", "Chilling", "Game", "Movie", "Festival", "Party", "Theather", "Social", "Outdoor", "Water Activities", "Self care", "Running", "Music", "Indoor sports", "Food", "Car", "Girl's Night", "Men's Night"]
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        self.hideKeyboardWhenTappedAround()
        registerForKeyboardNotifications()
        
        imagePicker.backgroundColor = UIColor.lightGray
    }

    //MARK: - Functions
    
    // Function to adjust scrollview when keyboard appears
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector:
            #selector(keyboardWasShown(_:)),
                                               name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:
            #selector(keyboardWillBeHidden(_:)),
                                               name: .UIKeyboardWillHide, object: nil)
    }
    
    // Function to adjust scrollview when keyboard appears
    @objc func keyboardWasShown(_ notificiation: NSNotification) {
        guard let info = notificiation.userInfo,
            let keyboardFrameValue =
            info[UIKeyboardFrameBeginUserInfoKey] as? NSValue
            else { return }
        
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0,
                                             keyboardSize.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    // Function to adjust scrollview when keyboard appears
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    // Function to pick image from library
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePicker.image = image
        imagePicker.contentMode = .scaleAspectFill
        
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        present(controller, animated: true, completion: nil)
    }
    
    //MARK: - Pickerview
    
    // Functions for pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        category = categories[row]
    }
    
    // Function to create activity when button pressed
    @IBAction func createActivty(_ sender: UIButton) {
        uploadData()
        clearAll()
    }
    
    // Function to upload all data to firebase
    func uploadData() {
        
        // Change format of the datepicker to String
        let date = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let stringDate = dateFormatter.string(from: date)
        
        //        // Send all data to Firebase
        //        ref.child("Activities").child(uid!).child("Created").childByAutoId().setValue(["activity" : activityName.text!, "category" : category, "participants(max)" : maxParticipants.text!, "date" : stringDate, "location" : locationActivity.text!, "description" : descriptionTextfield.text!, "participating(uid)" : ""])
        
        // Get snapshot of firebase data
        refHandle = ref.child("Users").child(uid!).observe(.value, with: { (snapshot) in
            
            // Check if snapshot isn't nil
            if (snapshot.value as? [String:AnyObject]) != nil {
                
                let user = User(snapshot: snapshot)
                
                self.userName = user.name
            }
        })
        
        // Send all data to Firebase
        ref.child("Activities").childByAutoId().setValue(["activity" : activityName.text!, "category" : category, "participants(max)" : maxParticipants.text!, "date" : stringDate, "location" : locationActivity.text!, "description" : descriptionTextfield.text!, "participating(uid)" : "", "creator" : uid, "organisor" : userName])
    }
    
//    // Function to retrieve username (organisor)
//    func getUserName() {
//        // Get snapshot of firebase data
//        refHandle = ref.child("Users").child(uid!).observe(.value, with: { (snapshot) in
//            
//            // Check if snapshot isn't nil
//            if (snapshot.value as? [String:AnyObject]) != nil {
//                
//                let user = User(snapshot: snapshot)
//    
//                self.userName = user.name
//            }
//        })
//    }
    
    // Function to clear the textfields
    func clearAll() {
        activityName.text = ""
        maxParticipants.text = ""
        locationActivity.text = ""
        descriptionTextfield.text = ""
    }
}
