//
//  CoatLengthModalVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/11/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

@objc protocol CoatLengthModalVCDelegate {
    @objc func didSelectItem(_ isSelect: Bool)
}
class CoatLengthModalVC: UIViewController {
    //MARK:- UIControl's Outlets
    
    @IBOutlet weak var lblHeader : UILabel!
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var btnClose : UIButton!
  
    @IBOutlet weak var btnhairLess: UIButton!
    @IBOutlet weak var btnShort: UIButton!
    @IBOutlet weak var btnMedium: UIButton!
    @IBOutlet weak var btnLong: UIButton!
    @IBOutlet weak var btnWire: UIButton!
    @IBOutlet weak var btnCurly: UIButton!
    @IBOutlet private var optionContainerVw: UIView!

    //MARK:- Class Variables
    weak var delegate: CoatLengthModalVCDelegate?
    var optionBtnArray:[UIButton] = []

    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    override func viewDidLayoutSubviews() {
        makeRoundView()
    }
    
    func makeRoundView(){
        btnClose.layer.cornerRadius = btnClose.frame.height/2
        btnClose.clipsToBounds = true
        
        btnhairLess.layer.cornerRadius = 10
        btnhairLess.clipsToBounds = true
        btnhairLess.layer.borderWidth = 1
        btnhairLess.layer.borderColor = UIColor.lightGray.cgColor
        
        btnShort.layer.cornerRadius = 10
        btnShort.clipsToBounds = true
        btnShort.layer.borderWidth = 1
        btnShort.layer.borderColor = UIColor.lightGray.cgColor
        
        btnMedium.layer.cornerRadius = 10
        btnMedium.clipsToBounds = true
        btnMedium.layer.borderWidth = 1
        btnMedium.layer.borderColor = UIColor.lightGray.cgColor
        
        btnLong.layer.cornerRadius = 10
        btnLong.clipsToBounds = true
        btnLong.layer.borderWidth = 1
        btnLong.layer.borderColor = UIColor.lightGray.cgColor
        
        btnWire.layer.cornerRadius = 10
        btnWire.clipsToBounds = true
        btnWire.layer.borderWidth = 1
        btnWire.layer.borderColor = UIColor.lightGray.cgColor
        
        btnCurly.layer.cornerRadius = 10
        btnCurly.clipsToBounds = true
        btnCurly.layer.borderWidth = 1
        btnCurly.layer.borderColor = UIColor.lightGray.cgColor
    }
   
    
    //MARK:- Custome Methods
    
    func configureUI(){
        //self.mainView.alpha = 0.0
        optionBtnArray = [btnhairLess,btnShort,btnMedium,btnLong,btnWire,btnCurly]
        for btn in optionBtnArray {
            if FilterItems.shared.isAlreadyItemSelected(btn.titleLabel?.text ?? "") {
                btn.backgroundColor = UIColor.init(rgb: 0x6e0b9c)
                btn.setTitleColor(.white, for: .normal)
                btn.isSelected = true
            }
           
        }
        self.view.backgroundColor = .clear
        self.presentAnimation()
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
    
    @IBAction func coatLengthButtonAction(_ sender: UIButton) {
        for btn in optionBtnArray {
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(.black, for: .normal)
            if btn.isSelected {
                FilterItems.shared.removeItem(btn.titleLabel?.text ?? "")
            }
            btn.isSelected = false
        }
        FilterItems.shared.addItem(sender.titleLabel?.text ?? "")
        sender.isSelected = true
        sender.backgroundColor = UIColor.init(rgb: 0x6e0b9c)
        sender.setTitleColor(.white, for: .normal)
    }

}
