//
//  ActivityDetailViewController.swift
//  Connect
//
//  Created by Michael Hu on 13-06-18.
//  Copyright © 2018 Michael Hu. All rights reserved.
//

import UIKit

class ActivityDetailViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var activityName: UILabel!
    @IBOutlet weak var organiserLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var participantsTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var button: UIButton!
    
    var activity: Activity2!
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Functions
    
    // Function to update the detailview
    func updateUI() {
        activityName.text = activity.activity
        organiserLabel.text = activity.organisor
        categoryLabel.text = activity.category
        participantsTextView.text = activity.participants
        dateLabel.text = activity.date
        locationLabel.text = activity.location
        descriptionTextField.text = activity.description
    }

}
