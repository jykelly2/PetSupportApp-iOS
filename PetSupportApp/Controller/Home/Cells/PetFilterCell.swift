//
//  PetFilterCell.swift
//  PetSupportApp
//
//  Created by Anish on 9/7/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

class PetFilterCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var downArrowImageView: UIImageView!
    @IBOutlet weak var lblFilterType: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.cornerRadius = 5
        containerView.clipsToBounds = true
    }
}
