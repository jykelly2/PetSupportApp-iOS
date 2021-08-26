//
//  ShelterFavOptionPopUpVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/14/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit


@objc protocol ShelterFavOptionPopUpVCDelegate {
        @objc func didShelterFavOptionClose(_ isSelect: Bool)
    }

class ShelterFavOptionPopUpVC: UIViewController {
    
    //MARK:- UIControl's Outlets
    
    @IBOutlet weak var lblShelterName : UILabel!
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var btnClose : UIButton!
  
    var favShelter:FavShelterModel?
    weak var delegate:ShelterFavOptionPopUpVCDelegate?
    
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
        if let _favShelter = favShelter {
            lblShelterName.text = _favShelter.shelterName
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
        self.delegate?.didShelterFavOptionClose(true)
        self.dismissAnimation()
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func removeFavoriteButtonAction(_ sender: UIButton) {
        
    }

}
