//
//  FavoriteListVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/13/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD


class PetListTableViewCell: UITableViewCell {
    //MARK:- UIControl's Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var lblPetName: UILabel!
    @IBOutlet weak var lblPetDescription: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnOption: UIButton!
    
    override func layoutSubviews() {
        petImageView.layer.cornerRadius = 10
        petImageView.clipsToBounds = true
    }
    
    func setValues(value:Animal){
        let mydate1 = value.createdAt
        let dateArr =  mydate1.components(separatedBy: "T")
              let mydate = dateArr[0]
              let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "yyyy-MM-dd" //Your date format
              dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
              let date = dateFormatter.date(from: mydate) //according to date format your date string
              let timeTogo = timeAgoSinceDate(date!, currentDate: Date(), numericDates: true)
        self.lblTime.text = "\(timeTogo)"
        self.lblPetName.text = value.name
        self.lblPetDescription.text = value.description
        self.getImages(imageArray: value.pictures)
    }
    func getImages(imageArray:[String]) {
        
        let params:[String:Any] = ["bucket":"Animal","pictures":imageArray]
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
            petImageView.sd_setImage(with: url, completed: nil)
        }
    }

}

class NoItemTableViewCell: UITableViewCell {
    //MARK:- UIControl's Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btnSelect: UIButton!
    
    override func layoutSubviews() {
    }
}



class FavoritePetListVC: UIViewController, PetFavOptionPopUpVCDelegate {
    func didFavPetOptionClose(_ isSelect: Bool) {
        
        if let parent = self.parent?.parent as? FavoriteVC{
            parent.hidefadeView()
            fetchAllPetsLikes()
            
        }
    }
    
    //MARK:- UIControl's Outlets
    @IBOutlet weak var lblTotalPets: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tblFavoritePet: UITableView!

    //MARK:- Class Variables
    let viewModel = PetViewModel()
    var favPetlists:[FavPetModel] = []
    var animalIds = [String]()
    var animals = [Animal]()
    var selectedAnimals = [Animal]()
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    override func viewDidLayoutSubviews() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchAllPetsLikes()
        if let parent = self.parent?.parent as? FavoriteVC{
            parent.selectIndex = 0
            parent.setViewSelection(index: 0)
        }
    }
    //MARK:- Custome Methods
    
    func configureUI(){
//        headerView.layer.borderWidth = 0.5
//        headerView.layer.borderColor = UIColor.black.cgColor

        tblFavoritePet.rowHeight = 250
        favPetlists = viewModel.favPetList
        lblTotalPets.text = "\(viewModel.favPetList.count) Pets"

    }

    
    //MARK:- Action Methods
    @objc func optionButtonAction(_ sender:UIButton){
        
        let vc = SFavorite.instantiateViewController(withIdentifier: "PetFavOptionPopUpVC") as! PetFavOptionPopUpVC
        self.addChild(vc)
        vc.favPetModel = selectedAnimals[sender.tag]
        vc.animalLikeIds = self.animalIds
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
extension FavoritePetListVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return selectedAnimals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PetListTableViewCell") as? PetListTableViewCell else { return UITableViewCell() }
        let favPetModel = selectedAnimals[indexPath.row]
        cell.setValues(value: favPetModel)
        cell.btnOption.tag = indexPath.row
        cell.btnOption.addTarget(self, action: #selector(optionButtonAction(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let favPetModel = selectedAnimals[indexPath.row]
         let vc = SHome.instantiateViewController(withIdentifier: "AnimalDetailVC") as! AnimalDetailVC
        //anish
        vc.animalLikedIds = animalIds
        vc.petModel = favPetModel
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension FavoritePetListVC {
    func fetchAllPetsLikes(){
        Alamofire.request("https://petsupportapp.com/api/clients/favourite/pets/\(USER_ID)", method: .get).responseJSON { (reponse) in
            if reponse.result.isSuccess {
                KRProgressHUD.show()
                let data:JSON = JSON(reponse.result.value!)
             
                self.parseLikes(json:data["favouritePets"])
            }else {
                print(reponse.result.error!.localizedDescription)
            }
        }
    }
    func parseLikes(json:JSON){
        animalIds.removeAll()
        for item in json {
            let id = item.1.string ?? ""
            self.animalIds.append(id)
        }
        KRProgressHUD.dismiss()
        getAnimalClient()
    }
    func getAnimalClient(){
        KRProgressHUD.show()
        let params:[String:Any] = ["favouriteIds":animalIds]
        Alamofire.request("https://petsupportapp.com/api/animals/client/favourites", method: .post,parameters: params).responseJSON { (reponse) in
            if reponse.result.isSuccess {
                
                let data:JSON = JSON(reponse.result.value!)
                print(data)
                self.parseValues(json: data["animals"])
            }else {
                print(reponse.result.error!.localizedDescription)
                KRProgressHUD.dismiss()
            }
        }
    }
    func parseValues(json:JSON){
        animals.removeAll()
        selectedAnimals.removeAll()
        for item in json {
            
            let name = item.1["name"].string ?? ""
            let type = item.1["animalType"].string ?? ""
            let breed = item.1["breed"].string ?? ""
            let gender = item.1["gender"].string ?? ""
            let age = item.1["age"].int ?? 0
            let size = item.1["size"].string ?? ""
            var personalities = [String]()
            let personalitiesArray = item.1["personalities"].array
            for item in personalitiesArray! {
                personalities.append(item.string ?? "")
            }
            let description = item.1["description"].string ?? ""
            let id = item.1["_id"].string ?? ""
            let createdAt = item.1["createdAt"].string ?? ""
            
            let isNeutered = item.1["isNeuteured"].bool ?? false
            let isVaccinated = item.1["isVaccinated"].bool ?? false
            let isPottyTrained = item.1["isPottyTrained"].bool ?? false
            let isLeashTrained = item.1["isLeashTrained"].bool ?? false
            let isAvailable = item.1["isAvailable"].bool ?? false
            let isAdobted = item.1["isAdopted"].bool ?? false
            let isScheduled = item.1["isScheduled"].bool ?? false
            var animalPicture = [String]()
            let pictures = item.1["pictures"].array
            for item in pictures! {
                animalPicture.append(item.string ?? "")
            //    getImages(imageArray:item.string ?? "")
            }
            //Shelter Values
            let postalCode = item.1["shelter"]["postalCode"].string ?? ""
            let city = item.1["shelter"]["city"].string ?? ""
            let streetAdd = item.1["shelter"]["streetAddress"].string ?? ""
            let province = item.1["shelter"]["province"].string ?? ""
            let shelterName = item.1["shelter"]["name"].string ?? ""
            let shelterId = item.1["shelter"]["_id"].string ?? ""
            let phoneNum = item.1["shelter"]["phoneNumber"].string ?? ""
            let email = item.1["shelter"]["email"].string ?? ""
           
            let data = Animal(name: name, type: type, breed: breed, gender: gender, age: age, size: size, personalities: personalities, description: description, id: id, isNeutered: isNeutered, isVaccinated: isVaccinated, isPottyTrained: isPottyTrained, isLeashTrained: isLeashTrained, isAvailable: isAvailable, isAdobted: isAdobted, isScheduled: isScheduled, pictures: animalPicture, createdAt: createdAt,shelter: Shelter(name: shelterName, email: email, phoneNumber: phoneNum, address: streetAdd, city: city, province: province, postalCode: postalCode, pictures:[""], shelterId: shelterId, description: ""))
            self.animals.append(data)
        }
        self.selectedAnimals = self.animals
        self.lblTotalPets.text = "\(selectedAnimals.count) Favourite Pets"
        self.tblFavoritePet.reloadData()
        KRProgressHUD.dismiss()
        
    }
}

/*
 MARK:- GENERAL SHARING
 let image = myImage.image
 let url =  "https://lyve.fm"
 let text = "this is lyve ios Dscvr application"
 let shareVC = UIActivityViewController(activityItems: [text,url,image!], applicationActivities: nil)
 self.present(shareVC, animated: true, completion: nil)
 */
