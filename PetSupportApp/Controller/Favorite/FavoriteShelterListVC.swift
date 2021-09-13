//
//  ShelterListVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/13/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD

class ShelterListTableViewCell: UITableViewCell {
    //MARK:- UIControl's Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shelterImageView: UIImageView!
    @IBOutlet weak var lblShelterName: UILabel!
    @IBOutlet weak var btnOption: UIButton!

  
    override func layoutSubviews() {
    }
    func setValues(value:Shelter){
        shelterImageView.layer.cornerRadius = 10
        shelterImageView.clipsToBounds = true
        self.lblShelterName.text = value.name
        self.getImages(imageArray: value.pictures)
    }
    func getImages(imageArray:[String]) {
        
        let params:[String:Any] = ["bucket":"Shelter","pictures":imageArray]
        Alamofire.request("https://petsupportapp.com/api/images/getImageUrls/", method:.post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            if response.result.isSuccess {
                let data : JSON = JSON(response.result.value!)
                self.parseImage(json: data)
            }else {
                print(response.result.error!.localizedDescription)
            }
        }
    }
    func parseImage(json:JSON){
        var images = [String]()
        for item in json {
            if let myItem = item.1.string {
                images.append(myItem)
            }
        }
        
        if let url = URL(string: images[0]){
            shelterImageView.sd_setImage(with:url, placeholderImage: UIImage(named: "close"), options: .scaleDownLargeImages)
        }
        
    }
}


class FavoriteShelterListVC: UIViewController,ShelterFavOptionPopUpVCDelegate  {
    func didShelterFavOptionClose(_ isSelect: Bool) {
        if let parent = self.parent?.parent as? FavoriteVC{
            parent.hidefadeView()
            fetchAllShelterLikes()
        }
    }
    
    //MARK:- UIControl's Outlets
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblTotalShelter: UILabel!
    @IBOutlet weak var tblFavoriteShelter: UITableView!

    //MARK:- Class Variables
    let viewModel = PetViewModel()
    var shelterList = [Shelter]()
    var favShelterlists:[Shelter] = []
    var shelterIds = [String]()
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    override func viewDidLayoutSubviews() {
    }
       
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllShelterLikes()
        if let parent = self.parent?.parent as? FavoriteVC{
            parent.selectIndex = 1
            parent.setViewSelection(index: 1)
        }
    }
    //MARK:- Custome Methods
    
    func configureUI(){
//        headerView.layer.borderWidth = 0.5
//        headerView.layer.borderColor = UIColor.black.cgColor
       
       
        lblTotalShelter.text = "\(viewModel.favShelterList.count) Shelters"

    }

    
    //MARK:- Action Methods
    @objc func optionButtonAction(_ sender:UIButton){
        
        let vc = SFavorite.instantiateViewController(withIdentifier: "ShelterFavOptionPopUpVC") as! ShelterFavOptionPopUpVC
        self.addChild(vc)
        vc.favShelter = favShelterlists[sender.tag]
        vc.shelterIds = shelterIds
        vc.delegate = self
        vc.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
        
        if let parent = self.parent?.parent as? FavoriteVC{
            parent.showfadeView()
        }
        
    }
    @objc func selectButtonAction(_ sender:UIButton){
    }

}

//MARK:- UITableViewDelegate,UITableViewDataSource
extension FavoriteShelterListVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return favShelterlists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShelterListTableViewCell") as? ShelterListTableViewCell else { return UITableViewCell() }
        let favShelterModel = favShelterlists[indexPath.row]
            cell.setValues(value: favShelterModel)
            cell.btnOption.tag = indexPath.row
        cell.btnOption.addTarget(self, action: #selector(optionButtonAction(_:)), for: .touchUpInside)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favShelter = favShelterlists[indexPath.row]
     
        let vc = SHome.instantiateViewController(withIdentifier: "ShelterDetailVC") as! ShelterDetailVC
        vc.shelter = favShelter
        vc.fromFav = true
       self.navigationController?.pushViewController(vc, animated: true)
   }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

}
extension FavoriteShelterListVC {
    func fetchAllShelterLikes(){
        Alamofire.request("https://petsupportapp.com/api/clients/favourite/shelters/\(USER_ID)", method: .get).responseJSON { (reponse) in
            if reponse.result.isSuccess {
                KRProgressHUD.show()
                let data:JSON = JSON(reponse.result.value!)
             
                self.parseLikes(json:data["favouriteShelters"])
            }else {
                print(reponse.result.error!.localizedDescription)
            }
        }
    }
    func parseLikes(json:JSON){
        shelterIds.removeAll()
        for item in json {
            let id = item.1.string ?? ""
            self.shelterIds.append(id)
        }
        KRProgressHUD.dismiss()
        getAnimalClient()
    }
    func getAnimalClient(){
        KRProgressHUD.show()
        let params:[String:Any] = ["favouriteIds":shelterIds]
        Alamofire.request("https://petsupportapp.com/api/shelters/client/favourites", method: .post,parameters: params).responseJSON { (reponse) in
            if reponse.result.isSuccess {
                
                let data:JSON = JSON(reponse.result.value!)
                print(data)
                self.parseShelter(json: data["shelters"])
            }else {
                print(reponse.result.error!.localizedDescription)
                KRProgressHUD.dismiss()
            }
        }
    }
    func parseShelter(json:JSON){
        shelterList.removeAll()
        favShelterlists.removeAll()
        for item in json {
            let postalCode = item.1["postalCode"].string ?? ""
            let city = item.1["city"].string ?? ""
            let streetAdd = item.1["streetAddress"].string ?? ""
            let province = item.1["province"].string ?? ""
            let shelterName = item.1["name"].string ?? ""
            let shelterId = item.1["_id"].string ?? ""
            let phoneNum = item.1["phoneNumber"].string ?? ""
            let email = item.1["email"].string ?? ""
            let des = item.1["description"].string ?? ""
            var shelterPictuers = [String]()
            let shelterPictuersArray = item.1["pictures"].array
            for item in shelterPictuersArray! {
                shelterPictuers.append(item.string ?? "")
            }
            
            let data = Shelter(name: shelterName, email: email, phoneNumber: phoneNum, address: streetAdd, city: city, province: province, postalCode: postalCode, pictures: shelterPictuers, shelterId: shelterId, description: des)
            self.shelterList.append(data)
        }
        self.favShelterlists = shelterList
        tblFavoriteShelter.reloadData()
        lblTotalShelter.text = "\(favShelterlists.count) Shelters"
        KRProgressHUD.dismiss()
    }
    
    
}
