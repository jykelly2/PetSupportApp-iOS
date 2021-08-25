//
//  DistanceFilterPopUpVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/11/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

@objc protocol DistanceModalVCDelegate {
    @objc func didSelectItem(_ isSelect: Bool)
}
class DistanceModalVC: UIViewController {
    //MARK:- UIControl's Outlets
    
    @IBOutlet weak var lblHeader : UILabel!
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var btnClose : UIButton!
    
    @IBOutlet weak var btnTenMiles: UIButton!
    @IBOutlet weak var btnCustomMiles: UIButton!
    @IBOutlet weak var btnHundredMiles: UIButton!
    @IBOutlet weak var btnFiftyMiles: UIButton!
    @IBOutlet weak var btnTwentyFiveMiles: UIButton!
    @IBOutlet private var distanceOptionContainerVw: UIView!

    //MARK:- Class Variables
    weak var delegate: DistanceModalVCDelegate?
    var distanceBtnArray:[UIButton] = []

    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    override func viewDidLayoutSubviews() {
        btnClose.layer.cornerRadius = btnClose.frame.height/2
        btnClose.clipsToBounds = true
        
        distanceOptionContainerVw.layer.cornerRadius = 10
        distanceOptionContainerVw.clipsToBounds = true
        distanceOptionContainerVw.layer.borderWidth = 1
        distanceOptionContainerVw.layer.borderColor = UIColor.black.cgColor
    }
   
    
    //MARK:- Custome Methods
    func configureUI(){
        //self.mainView.alpha = 0.0
        self.view.backgroundColor = .clear
        self.presentAnimation()
        
        distanceBtnArray = [btnTenMiles,btnTwentyFiveMiles,btnFiftyMiles,btnHundredMiles,btnCustomMiles]
        
        for btn in distanceBtnArray {
            if FilterItems.shared.isAlreadyItemSelected(btn.titleLabel?.text ?? "") {
                btn.backgroundColor = UIColor.init(rgb: 0x6e0b9c)
                btn.setTitleColor(.white, for: .normal)
            }
           
        }

    }

    func presentAnimation(){
        
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    func dismissAnimation(){
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }) { (finished : Bool) in
            if (finished){
                self.view.removeFromSuperview()
            }
        }
    }
    
    //MARK:- Action Methods
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.delegate?.didSelectItem(true)
        self.dismissAnimation()
    }
    
    @IBAction func distanceAction(_ sender: UIButton) {
        for btn in distanceBtnArray {
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(.black, for: .normal)
            if btn.isSelected {
                FilterItems.shared.removeItem(btn.titleLabel?.text ?? "")
            }
        }
        FilterItems.shared.addItem(sender.titleLabel?.text ?? "")

        sender.backgroundColor = UIColor.init(rgb: 0x6e0b9c)
        sender.setTitleColor(.white, for: .normal)
    }

}
