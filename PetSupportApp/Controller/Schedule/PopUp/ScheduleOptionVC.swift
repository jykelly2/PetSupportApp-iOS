//
//  ScheduleOptionVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/15/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

class ScheduleOptionVC: UIViewController {
    
    //MARK:- UIControl's Outlets
    
    @IBOutlet weak var lblPetName : UILabel!
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var btnClose : UIButton!
  
    var scheduleListModel:ScheduleListModel?

    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    override func viewDidLayoutSubviews() {
        btnClose.layer.cornerRadius = btnClose.frame.height/2
        btnClose.clipsToBounds = true
    }
   
    
    //MARK:- Custome Methods
    
    func configureUI(){
        if let _scheduleListModel = scheduleListModel {
            lblPetName.text = _scheduleListModel.petName
        }
        //self.mainView.alpha = 0.0
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
    
    @IBAction func viewScheduleButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func viewPetButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func viewShelterButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func cancelScheduleButtonAction(_ sender: UIButton) {
        
    }
        
    @IBAction func scheduleButtonAction(_ sender: UIButton) {
        /*
        let vc = SMain.instantiateViewController(withIdentifier: "CreateScheduleModalVC") as! CreateScheduleModalVC
        self.addChild(vc)
        vc.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
        */
    }
    
    

}
