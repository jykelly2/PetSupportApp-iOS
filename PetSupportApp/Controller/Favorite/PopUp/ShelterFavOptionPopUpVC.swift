//
//  ShelterFavOptionPopUpVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/14/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit
import Alamofire
import KRProgressHUD
import SwiftyJSON

@objc protocol ShelterFavOptionPopUpVCDelegate {
        @objc func didShelterFavOptionClose(_ isSelect: Bool)
    }

class ShelterFavOptionPopUpVC: UIViewController {
    
    //MARK:- UIControl's Outlets
    
    @IBOutlet weak var lblShelterName : UILabel!
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var btnClose : UIButton!
  
    var favShelter:Shelter?
    weak var delegate:ShelterFavOptionPopUpVCDelegate?
    var shelterIds = [String]()
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
            lblShelterName.text = _favShelter.name
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
        let image = ""
        let url =  "https://petsupport.com"
        let text = "Support \(favShelter!.name)"
        let shareVC = UIActivityViewController(activityItems: [text,url,image], applicationActivities: nil)
        self.present(shareVC, animated: true, completion: nil)
    }
    
    @IBAction func removeFavoriteButtonAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Pet Support", message: "Are you sure you want to unlike \(favShelter!.name)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default) { (action) in
            self.shelterIds.removeAll { $0 == "\(self.favShelter!.shelterId)" }
            self.Shelterlike(Ids: self.shelterIds)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    func Shelterlike(Ids:[String]){
        KRProgressHUD.show()
        let params : [String : Any] = ["favouriteShelters":Ids]
        Alamofire.request("https://petsupportapp.com/api/clients/favourite/shelters/update/\(USER_ID)", method: .post,parameters: params).responseJSON { (reponse) in
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
