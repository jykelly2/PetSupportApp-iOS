//
//  PetFavOptionPopUpVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/14/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit
import MessageUI
import Alamofire
import SwiftyJSON
import KRProgressHUD

@objc protocol PetFavOptionPopUpVCDelegate {
    @objc func didFavPetOptionClose(_ isSelect: Bool)
}

class PetFavOptionPopUpVC: UIViewController,MFMailComposeViewControllerDelegate {
    
    //MARK:- UIControl's Outlets
    
    @IBOutlet weak var lblPetName : UILabel!
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var btnClose : UIButton!
    @IBOutlet weak var intoduceText: UILabel!
    
    var favPetModel: Animal?
    var animalLikeIds = [String]()
    weak var delegate:PetFavOptionPopUpVCDelegate?
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
        if let _favPetModel = favPetModel {
            lblPetName.text = _favPetModel.name
            intoduceText.text = "QUESTION ABOUT \(favPetModel!.name.capitalized)"
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
        self.delegate?.didFavPetOptionClose(true)
        self.dismissAnimation()
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
        print("share")
        let image = ""
        let url =  "https://petsupport.com"
        let text = "Support \(favPetModel!.name)"
        let shareVC = UIActivityViewController(activityItems: [text,url,image], applicationActivities: nil)
        self.present(shareVC, animated: true, completion: nil)
    }
    
    @IBAction func introduceYourselfButtonAction(_ sender: UIButton) {
        print("introduce")
        sendEmail()
    }
    
    @IBAction func viewPetProfileButtonAction(_ sender: UIButton) {
        print("view profile")
        
        let vc = SHome.instantiateViewController(withIdentifier: "AnimalDetailVC") as! AnimalDetailVC
        //anish
        vc.petModel = favPetModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func removeFavoriteButtonAction(_ sender: UIButton) {
        print("remove fav")
        let alert = UIAlertController(title: "Pet Support", message: "Are you sure you want to unlike \(favPetModel!.name)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default) { (action) in
            self.animalLikeIds.removeAll { $0 == "\(self.favPetModel!.id)" }
            self.unlike(petId: self.animalLikeIds)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func scheduleButtonAction(_ sender: UIButton) {
        
        let vc = SHome.instantiateViewController(withIdentifier: "CreateScheduleModalVC") as! CreateScheduleModalVC
        self.addChild(vc)
        vc.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
        
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["ved.ios@yopmail.com"])
            mail.setMessageBody("<p>support \(favPetModel!.name)!</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func unlike(petId:[String]){
        KRProgressHUD.show()
        
        let params : [String : Any] = ["favouritePets":petId]
        Alamofire.request("https://petsupportapp.com/api/clients/favourite/pets/update/\(USER_ID)", method: .post,parameters: params).responseJSON { (reponse) in
            if reponse.result.isSuccess {
                let data:JSON = JSON(reponse.result.value!)
                print(data)
                KRProgressHUD.dismiss()
            }else {
                print(reponse.result.error!.localizedDescription)
            }
        }
    }
}
