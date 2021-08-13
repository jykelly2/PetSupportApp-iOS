//
//  AgesFilterPopUpVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/11/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

class AgeModalVC: UIViewController {
    //MARK:- UIControl's Outlets
    
    @IBOutlet weak var lblHeader : UILabel!
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var btnClose : UIButton!
  
    @IBOutlet weak var btnBaby: UIButton!
    @IBOutlet weak var btnYoung: UIButton!
    @IBOutlet weak var btnAdult: UIButton!
    @IBOutlet weak var btnSenior: UIButton!
    @IBOutlet private var optionContainerVw: UIView!

    //MARK:- Class Variables
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
        
        btnBaby.layer.cornerRadius = 10
        btnBaby.clipsToBounds = true
        btnBaby.layer.borderWidth = 1
        btnBaby.layer.borderColor = UIColor.lightGray.cgColor
        
        btnYoung.layer.cornerRadius = 10
        btnYoung.clipsToBounds = true
        btnYoung.layer.borderWidth = 1
        btnYoung.layer.borderColor = UIColor.lightGray.cgColor
        
        btnAdult.layer.cornerRadius = 10
        btnAdult.clipsToBounds = true
        btnAdult.layer.borderWidth = 1
        btnAdult.layer.borderColor = UIColor.lightGray.cgColor
        
        btnSenior.layer.cornerRadius = 10
        btnSenior.clipsToBounds = true
        btnSenior.layer.borderWidth = 1
        btnSenior.layer.borderColor = UIColor.lightGray.cgColor
    }
   
    
    //MARK:- Custome Methods
    
    func configureUI(){
        //self.mainView.alpha = 0.0
        optionBtnArray = [btnBaby,btnYoung,btnAdult,btnSenior]

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
        self.dismissAnimation()
    }
    
    @IBAction func ageButtonAction(_ sender: UIButton) {
        for btn in optionBtnArray {
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(.black, for: .normal)
        }
        
        sender.backgroundColor = UIColor.init(rgb: 0x6e0b9c)
        sender.setTitleColor(.white, for: .normal)

    }

}
