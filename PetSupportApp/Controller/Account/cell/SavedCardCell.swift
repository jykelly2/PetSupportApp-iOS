//
//  SavedCardCell.swift
//  PetSupportApp
//
//  Created by Anish on 9/17/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

class SavedCardCell: UITableViewCell {

    @IBOutlet weak var cardNumber:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
