//
//  SizeModalVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/11/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

class SizeModalVC: UIViewController {
    //MARK:- UIControl's Outlets
    
    @IBOutlet weak var lblHeader : UILabel!
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var btnClose : UIButton!
  
    @IBOutlet weak var btnSmallSize: UIButton!
    @IBOutlet weak var btnMediumSize: UIButton!
    @IBOutlet weak var btnLargeSize: UIButton!
    @IBOutlet weak var btnXLSize: UIButton!
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
        
        btnSmallSize.layer.cornerRadius = 10
        btnSmallSize.clipsToBounds = true
        btnSmallSize.layer.borderWidth = 1
        btnSmallSize.layer.borderColor = UIColor.lightGray.cgColor
        
        btnMediumSize.layer.cornerRadius = 10
        btnMediumSize.clipsToBounds = true
        btnMediumSize.layer.borderWidth = 1
        btnMediumSize.layer.borderColor = UIColor.lightGray.cgColor
        
        btnLargeSize.layer.cornerRadius = 10
        btnLargeSize.clipsToBounds = true
        btnLargeSize.layer.borderWidth = 1
        btnLargeSize.layer.borderColor = UIColor.lightGray.cgColor
        
        btnXLSize.layer.cornerRadius = 10
        btnXLSize.clipsToBounds = true
        btnXLSize.layer.borderWidth = 1
        btnXLSize.layer.borderColor = UIColor.lightGray.cgColor
    }
   
    
    //MARK:- Custome Methods
    
    func configureUI(){
        //self.mainView.alpha = 0.0
        optionBtnArray = [btnSmallSize,btnMediumSize,btnLargeSize,btnXLSize]

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
    
    @IBAction func sizeButtonAction(_ sender: UIButton) {
        for btn in optionBtnArray {
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(.black, for: .normal)
        }
        
        sender.backgroundColor = UIColor.init(rgb: 0x6e0b9c)
        sender.setTitleColor(.white, for: .normal)

    }

}
