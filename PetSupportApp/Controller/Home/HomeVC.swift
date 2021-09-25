//
//  HomeVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/8/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD

//MARK:- HOME VC CLASS
class HomeVC: UIViewController, BreadModalVCDelegate, ShelterRescueModalVCDelegate, ColarModalVCDelegate, DistanceModalVCDelegate, AgeModalVCDelegate, SizeModalVCDelegate, GoodWithModalVCDelegate, CoatLengthModalVCDelegate, FilterVCDelegate, SortModalVCDelegate {
    
    
    func selectedAge(age: String) {
        //delegate for age selectionPopUp
    }
    func didSelectBreadItem(_ item: String) {
        print(item)
    }
    
    func didSelectSortItem(_ sortedBy: String) {
        if sortedBy.count > 0 {
//this delegate works on animal tableview sorting for new/old etc
            self.lblSortedTxt.text = sortedBy
        }
    }
    
    func didSelectItem(_ isSelect: Bool) {
        //this function is calling when closing the popup window
        if self.filterMasterMenuArray.count > 0  {
            self.filterMenuArray = []
            self.filterMenuArray.append(contentsOf: FilterItems.shared.filterItemArray)
            self.filterMenuArray.append(contentsOf: self.filterMasterMenuArray)
            self.filterCollectionView.reloadData()
            lblTotalFilter.text = "\(FilterItems.shared.filterItemArray.count)"
        }
        
        if FilterItems.shared.sortedItemArray.count > 0 {
            lblSortedTxt.text = FilterItems.shared.sortedItemArray[0].title
        }else{
            lblSortedTxt.text = "Newest Addition"
        }
    }
    
    //MARK:- UIControl's Outlets
    @IBOutlet weak var topSearchingView: UIView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var petTableView: UITableView!
    @IBOutlet weak var txtPetCurrentLocation: UITextField!
    @IBOutlet weak var lblTotalResult: UILabel!
    @IBOutlet weak var lblSortedTxt: UILabel!
    @IBOutlet weak var lblTotalFilter: UILabel!

    //MARK:- Class Variables
    let viewModel = PetViewModel()
    var filterMasterMenuArray : [FilterMenu] = []
    var filterMenuArray : [FilterMenu] = []
    var animalClient = [Animal]()
    var currentAnimalClient = [Animal]()
    var animalSelectedId = [String]()
    var animalLikedIds = [String]()
    var petFavBtnIndex : Int?
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        petTableView.rowHeight = 490
        updateUI()
        setFilterMenu()
        let vw = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 100))
        vw.backgroundColor = UIColor.blue
       // petTableView.tableHeaderView = bannarView
        
        self.petTableView.delegate = self
        self.petTableView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        if let firstName  = UserDefaults.standard.object(forKey: "firstName") {
            if let lastName = UserDefaults.standard.object(forKey: "lastName"){
                NAME = "\(firstName) \(lastName)"
                FIRST_NAME = firstName as! String
                LAST_NAME = lastName as! String
            }
        }
        if let userId  = UserDefaults.standard.object(forKey: "userId") {
            USER_ID = userId as! String
        }
        if let email  = UserDefaults.standard.object(forKey: "email") {
            EMAIL = email as! String
            self.signIn(email: EMAIL)
        }
        if let isLoggedIn  = UserDefaults.standard.object(forKey: "isLoggedIn") {
            LOGGED_IN = isLoggedIn as! Bool
        }
        print("THIS IS MY USER ID = \(USER_ID)")
        self.fetchAllPetsLikes()
        
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK:- Custome Methods
    func setFilterMenu(){
        self.filterMasterMenuArray = []
        self.filterMasterMenuArray.append(FilterMenu(title: "Distance", modalMenu: FilterModalMenu.DistanceModalVC))
        self.filterMasterMenuArray.append(FilterMenu(title: "Breeds", modalMenu: FilterModalMenu.BreadModalVC))
        self.filterMasterMenuArray.append(FilterMenu(title: "Ages", modalMenu: FilterModalMenu.AgeModalVC))
        self.filterMasterMenuArray.append(FilterMenu(title: "Sizes", modalMenu: FilterModalMenu.SizeModalVC))
        self.filterMasterMenuArray.append(FilterMenu(title: "Shelter & Rescues", modalMenu: FilterModalMenu.ShelterRescueModalVC))
        self.filterMasterMenuArray.append(FilterMenu(title: "Good With", modalMenu: FilterModalMenu.GoodWithModalVC))
        self.filterMasterMenuArray.append(FilterMenu(title: "Coat Length", modalMenu: FilterModalMenu.CoatLengthModalVC))
        self.filterMasterMenuArray.append(FilterMenu(title: "Colors", modalMenu: FilterModalMenu.ColarModalVC))
        self.filterMenuArray = filterMasterMenuArray

        self.filterCollectionView.reloadData()
        
    }
    
    func updateUI(){
        txtPetCurrentLocation.delegate = self
        topSearchingView.layer.cornerRadius = 10
        topSearchingView.clipsToBounds = true
        topSearchingView.layer.borderWidth = 1
        topSearchingView.layer.borderColor = UIColor.lightGray.cgColor
        lblTotalFilter.layer.cornerRadius = lblTotalFilter.frame.height/2
        lblTotalFilter.clipsToBounds = true
    }
    
    
    func goToAnimalDetailVC(_ petModel:Animal){
        let vc = SHome.instantiateViewController(withIdentifier: "AnimalDetailVC") as! AnimalDetailVC
        //vc.hidesBottomBarWhenPushed = true
        vc.animalSelectedId = animalSelectedId
        vc.animalLikedIds = animalLikedIds
        vc.petModel = petModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:-Go To Filter Screen
    
    func goToFilterModalVC(_ filterMenu:FilterMenu) {
        if filterMenu.filterModalMenu ==  FilterModalMenu.Filter{
            FilterItems.shared.removeItem(filterMenu.title)
            self.filterMenuArray = self.filterMenuArray.filter { $0.title != filterMenu.title}
            filterCollectionView.reloadData()
            lblTotalFilter.text = "\(FilterItems.shared.filterItemArray.count)"
        }else{
        switch filterMenu.filterModalMenu {
        case .BreadModalVC:
            let destVC:BreadModalVC!  = SHome.instantiateViewController(withIdentifier: filterMenu.filterModalMenu.rawValue) as? BreadModalVC
            destVC.delegate = self
            self.addChild(destVC)
            destVC.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(destVC.view)
            destVC.didMove(toParent: self)
            
        case .ShelterRescueModalVC:
            let destVC:ShelterRescueModalVC!  = SHome.instantiateViewController(withIdentifier: filterMenu.filterModalMenu.rawValue) as? ShelterRescueModalVC
            destVC.delegate = self
            self.addChild(destVC)
            destVC.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(destVC.view)
            destVC.didMove(toParent: self)
            
        case .ColarModalVC:
            let destVC:ColarModalVC!  = SHome.instantiateViewController(withIdentifier: filterMenu.filterModalMenu.rawValue) as? ColarModalVC
            destVC.delegate = self
            self.addChild(destVC)
            destVC.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(destVC.view)
            destVC.didMove(toParent: self)
            
        case .DistanceModalVC:
            let destVC:DistanceModalVC!  = SHome.instantiateViewController(withIdentifier: filterMenu.filterModalMenu.rawValue) as? DistanceModalVC
            destVC.delegate = self
            self.addChild(destVC)
            destVC.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(destVC.view)
            destVC.didMove(toParent: self)
            
        case .AgeModalVC:
            let destVC:AgeModalVC!  = SHome.instantiateViewController(withIdentifier: filterMenu.filterModalMenu.rawValue) as? AgeModalVC
            destVC.delegate = self
            self.addChild(destVC)
            destVC.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(destVC.view)
            destVC.didMove(toParent: self)
            
        case .SizeModalVC:
            let destVC:SizeModalVC!  = SHome.instantiateViewController(withIdentifier: filterMenu.filterModalMenu.rawValue) as? SizeModalVC
            destVC.delegate = self
            self.addChild(destVC)
            destVC.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(destVC.view)
            destVC.didMove(toParent: self)
            
        case .GoodWithModalVC:
            let destVC:GoodWithModalVC!  = SHome.instantiateViewController(withIdentifier: filterMenu.filterModalMenu.rawValue) as? GoodWithModalVC
            destVC.delegate = self
            self.addChild(destVC)
            destVC.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(destVC.view)
            destVC.didMove(toParent: self)
            
        case .CoatLengthModalVC:
            let destVC:CoatLengthModalVC!  = SHome.instantiateViewController(withIdentifier: filterMenu.filterModalMenu.rawValue) as? CoatLengthModalVC
            destVC.delegate = self
            self.addChild(destVC)
            destVC.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(destVC.view)
            destVC.didMove(toParent: self)
            
        default:
            let destVC:UIViewController!  = SHome.instantiateViewController(withIdentifier: filterMenu.filterModalMenu.rawValue)
            self.addChild(destVC)
            destVC.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(destVC.view)
            destVC.didMove(toParent: self)

           }
        }
    }
    
    
   
    //MARK:- Action Methods
    @IBAction func filterAction(_ sender: UIButton) {
        let vc = SHome.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        vc.delegate = self
        vc.hidesBottomBarWhenPushed = true
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func mapButtonAction(_ sender: UIButton) {
        let vc = SHome.instantiateViewController(withIdentifier: "MapVC") as! MapVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func sortButtonAction(_ sender: UIButton) {
        let destVC = SHome.instantiateViewController(withIdentifier: "SortModalVC") as! SortModalVC
        self.addChild(destVC)
        destVC.delegate = self
        destVC.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(destVC.view)
        destVC.didMove(toParent: self)
    }
    
    
}

//MARK:- UITableViewDelegate,UITableViewDataSource
extension HomeVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAnimalClient.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PetTableViewCell") as? PetTableViewCell else { return UITableViewCell() }
        let petModel = currentAnimalClient[indexPath.row]
        cell.delegate = self
        cell.btnShare.tag = indexPath.row
        cell.btnShare.addTarget(self, action: #selector(shareBtnTapped(sender:)), for: .touchUpInside)
        cell.btnFavorite.tag = indexPath.row
        cell.btnFavorite.addTarget(self, action: #selector(favBtnTapped(sender:)), for: .touchUpInside)
        cell.setValues(values: petModel)
        if self.animalLikedIds.contains(petModel.id) {
            cell.btnFavorite.setImage(UIImage(named:"liked"), for: .normal)
        }else {
            cell.btnFavorite.setImage(UIImage(named:"like"), for: .normal)
        }


        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let petModel = currentAnimalClient[indexPath.row]
        goToAnimalDetailVC(petModel)
    }
    @objc func favBtnTapped(sender:UIButton!){
      
        let index = IndexPath(row: sender.tag, section: 0)
        let cell = petTableView.cellForRow(at: index) as! PetTableViewCell
        let petModel = currentAnimalClient[sender.tag]
        self.petFavBtnIndex = sender.tag
        if self.animalLikedIds.contains(petModel.id) {
            cell.btnFavorite.setImage(UIImage(named:"liked"), for: .normal)
            animalSelectedId.removeAll { $0 == "\(petModel.id)" }
            animalLikedIds.removeAll { $0 == "\(petModel.id)" }
            like(petId: animalSelectedId)
            petTableView.reloadData()
        }else {
            cell.btnFavorite.setImage(UIImage(named:"like"), for: .normal)
            animalSelectedId.append(petModel.id)
            animalLikedIds.append(petModel.id)
            petTableView.reloadData()
            like(petId: animalSelectedId)
        }
    }
    @objc func shareBtnTapped(sender:UIButton!){
       
        let petModel = currentAnimalClient[sender.tag]
        let image = ""
        let url =  "https://petsupport.com"
        let text = "Support \(petModel.name)"
        let shareVC = UIActivityViewController(activityItems: [text,url,image], applicationActivities: nil)
        self.present(shareVC, animated: true, completion: nil)
     
    }

}

extension HomeVC:PetTableViewCellDelegate{
    func didSelectItem(_ petModel: Animal?) {
        if let _petModel = petModel {
            goToAnimalDetailVC(_petModel)
        }
    }    
}

//MARK:- FILTER UICollectionViewDelegate,UICollectionViewDataSource
extension HomeVC: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return filterMenuArray.count

      }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as!
            PetFilterCell
        let filterMenu = filterMenuArray[indexPath.row]
        cell.lblFilterType.text = filterMenu.title
        if filterMenu.filterModalMenu == .Filter {
            cell.lblFilterType.textColor = .white
            cell.containerView.backgroundColor = UIColor(rgb: 0x6E0B9C)
            cell.downArrowImageView.image = UIImage(named: "close")
        }else{
            cell.lblFilterType.textColor = .darkGray
            cell.containerView.backgroundColor = .white
            cell.downArrowImageView.image = UIImage(named: "down-arrow")
        }
       

        return cell

      }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filterMenu = filterMenuArray[indexPath.row]
        self.goToFilterModalVC(filterMenu)
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let label = UILabel(frame: CGRect.zero)
        label.text = filterMenuArray[indexPath.item].title
            label.sizeToFit()
            return CGSize(width: label.frame.width + 35, height: filterCollectionView.frame.size.height)
        }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

//MARK:- UITextFieldDelegate
extension HomeVC:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        let vc = SHome.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        vc.hidesBottomBarWhenPushed = true
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        //self.navigationController?.pushViewController(vc, animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()

        return true
    }
}

//MARK:- NETWORK CALLS

extension HomeVC {
    func getAnimalClient(){
        KRProgressHUD.show()
        Alamofire.request("https://petsupportapp.com/api/animals/client/", method: .get).responseJSON { (reponse) in
            if reponse.result.isSuccess {
                KRProgressHUD.show()
                let data:JSON = JSON(reponse.result.value!)
                self.parseValues(json: data["animals"])
            }else {
                print(reponse.result.error!.localizedDescription)
                KRProgressHUD.dismiss()
            }
        }
    }
    func parseValues(json:JSON){
        animalClient.removeAll()
        currentAnimalClient.removeAll()
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
            var shelterPictuers = [String]()
            let shelterPictuersArray = item.1["shelter"]["pictures"].array
            for item in shelterPictuersArray! {
                shelterPictuers.append(item.string ?? "")
            }
            let data = Animal(name: name, type: type, breed: breed, gender: gender, age: age, size: size, personalities: personalities, description: description, id: id, isNeutered: isNeutered, isVaccinated: isVaccinated, isPottyTrained: isPottyTrained, isLeashTrained: isLeashTrained, isAvailable: isAvailable, isAdobted: isAdobted, isScheduled: isScheduled, pictures: animalPicture, createdAt: createdAt,shelter: Shelter(name: shelterName, email: email, phoneNumber: phoneNum, address: streetAdd, city: city, province: province, postalCode: postalCode, pictures: shelterPictuers, shelterId: shelterId, description: ""))
            self.animalClient.append(data)
        }
        self.currentAnimalClient = self.animalClient
        lblTotalResult.text = "\(currentAnimalClient.count) Results"
        self.petTableView.reloadData()
        KRProgressHUD.dismiss()
        
    }
    
    func fetchAllPetsLikes(){
        Alamofire.request("https://petsupportapp.com/api/clients/favourite/pets/\(USER_ID)", method: .get).responseJSON { (reponse) in
            if reponse.result.isSuccess {
                KRProgressHUD.show()
                let data:JSON = JSON(reponse.result.value!)
                self.parseLikes(json:data["favouritePets"])
            }else {
                //in case user id not signed in 
                self.getAnimalClient()
                self.animalLikedIds.removeAll()
                self.animalSelectedId.removeAll()
                print(reponse.result.error!.localizedDescription)
            }
        }
    }
    func parseLikes(json:JSON){
        animalLikedIds.removeAll()
        for item in json {
            let id = item.1.string ?? ""
            self.animalLikedIds.append(id)
        }
        animalSelectedId = animalLikedIds
        getAnimalClient()
        KRProgressHUD.dismiss()
    }
    
    func like(petId:[String]){
        KRProgressHUD.show()
        let petsId = self.animalSelectedId.removeDuplicates()
        let params : [String : Any] = ["favouritePets":petsId]
        Alamofire.request("https://petsupportapp.com/api/clients/favourite/pets/update/\(USER_ID)", method: .post,parameters: params).responseJSON { (reponse) in
            if reponse.result.isSuccess {
                let data:JSON = JSON(reponse.result.value!)
              
                KRProgressHUD.dismiss()
            }else {
                print(reponse.result.error!.localizedDescription)
            }
        }
    }
    func signIn(email:String) {
        KRProgressHUD.show()
        let params = ["email":email]
        Alamofire.request("https://petsupportapp.com/api/clients/login", method: .post, parameters: params).responseJSON { (response) in
            if response.result.isSuccess {
                let result:JSON = JSON(response.result.value!)
                print(result)
                self.parseSigninValues(json: result)
            }else {
                KRProgressHUD.dismiss()
                print(response.result.error!.localizedDescription)
            }
        }
    }
    func parseSigninValues(json:JSON){
        let payment_CardSaved = json["paymentCardSaved"].bool ?? false
        let profile_Completed = json["profileCompleted"].bool ?? false
        let scheduler_ProfileCompleted = json["schedulerProfileCompleted"].bool ?? false
        let petPreference_Completed = json["petPreferenceCompleted"].bool ?? false
        paymentCardSaved = payment_CardSaved
        profileCompleted = profile_Completed
        schedulerProfileCompleted = scheduler_ProfileCompleted
        petPreferenceCompleted = petPreference_Completed
        KRProgressHUD.dismiss()

    }

}

