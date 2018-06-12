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

class CreateActivityViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: - Outlets
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var activityName: UITextField!
    @IBOutlet weak var maxParticipants: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var locationActivity: UITextField!
    
    //MARK: - Variables
    
    var ref: DatabaseReference!
    var category: String!

    let categories = ["Sports", "Chilling", "Game", "Movie", "Festival", "Party", "Theather", "Social", "Outdoor", "Water Activities", "Self care", "Running", "Music", "Send", "Nudes" ]
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }

    // Function to create activity when button pressed
    @IBAction func createActivty(_ sender: UIButton) {
        let uid = Auth.auth().currentUser?.uid
        
        // Change format of the datepicker to String
        let date = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let stringDate = dateFormatter.string(from: date)
       
        // Send all data to Firebase
        ref.child("Activities").child(uid!).setValue(["activity" : activityName.text!, "category" : category, "participants(max)" : maxParticipants.text!, "date" : stringDate, "location" : locationActivity.text!])
    }
}
