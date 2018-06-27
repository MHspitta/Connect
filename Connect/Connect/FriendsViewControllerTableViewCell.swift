//
//  FriendsViewControllerTableViewCell.swift
//  Connect
//
//  Created by Michael Hu on 27-06-18.
//  Copyright © 2018 Michael Hu. All rights reserved.
//

import UIKit

class FriendsViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
