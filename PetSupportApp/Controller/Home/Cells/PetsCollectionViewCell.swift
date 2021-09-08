//
//  PetsCollectionViewCell.swift
//  PetSupportApp
//
//  Created by Anish on 9/7/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

class PetsCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var lblPetType: UILabel!
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var circleView: UIView!
    
    override func layoutSubviews() {
        circleView.layer.borderWidth = 1
        circleView.layer.borderColor = UIColor.white.cgColor
        
        circleView.layer.cornerRadius = circleView.frame.height/2
        circleView.clipsToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
}
