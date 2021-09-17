//
//  SignInModalVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/18/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

protocol SignInModalVCDelegate {
    func didSelectSignOption(_ controller: SignInModalVC, signInOption: Int)
}

class SignInModalVC: UIViewController {
    
    //MARK:- UIControl's Outlets
    
    @IBOutlet weak var lblPetName : UILabel!
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var btnClose : UIButton!
    
    @IBOutlet weak var btnSigninGoogle: UIButton!
    @IBOutlet weak var btnSigninFaceBook: UIButton!
    @IBOutlet weak var btnSigninApple: UIButton!
    @IBOutlet weak var btnSigninEmail: UIButton!
  

    //MARK:- Class Variables
    var delegate:SignInModalVCDelegate?
    
    var signinBtnArray:[UIButton] = []
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    override func viewDidLayoutSubviews() {
        makeRound()
    }
   
    
    //MARK:- Custome Methods
    
    func makeRound(){
        btnClose.layer.cornerRadius = btnClose.frame.height/2
        btnClose.clipsToBounds = true
        
        btnSigninGoogle.layer.cornerRadius = btnClose.frame.height/2
        btnSigninGoogle.clipsToBounds = true
        
        btnSigninFaceBook.layer.cornerRadius = btnClose.frame.height/2
        btnSigninFaceBook.clipsToBounds = true
        
        btnSigninApple.layer.cornerRadius = btnClose.frame.height/2
        btnSigninApple.clipsToBounds = true
        
        btnSigninEmail.layer.cornerRadius = btnClose.frame.height/2
        btnSigninEmail.clipsToBounds = true
    }
    
    func configureUI(){
        //self.mainView.alpha = 0.0
        self.view.backgroundColor = .clear
        self.presentAnimation()
        
        signinBtnArray = [btnSigninGoogle,btnSigninFaceBook,btnSigninApple,btnSigninEmail]

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
    
    @IBAction func signInButtonAction(_ sender: UIButton) {
        for btn in signinBtnArray {
            btn.backgroundColor = UIColor.lightGray
            btn.setTitleColor(.black, for: .normal)
        }
        
        sender.backgroundColor = UIColor(rgb: 0x000000)
        sender.setTitleColor(.white, for: .normal)
        self.delegate?.didSelectSignOption(self, signInOption: sender.tag)
        self.dismissAnimation()
    }
        
//    @IBAction func scheduleButtonAction(_ sender: UIButton) {
//
//        let vc = SMain.instantiateViewController(withIdentifier: "CreateScheduleModalVC") as! CreateScheduleModalVC
//        self.addChild(vc)
//        vc.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
//        self.view.addSubview(vc.view)
//        vc.didMove(toParent: self)
//
//    }
    
    

}
