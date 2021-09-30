//
//  ShelterDetailVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/10/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD


class ShelterPetCollectionVC: UICollectionViewCell {
    
    @IBOutlet weak var lblPetType: UILabel!
    @IBOutlet weak var lblPetName: UILabel!
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var circleView: UIView!
  
    func setValues(value:Animal){
        lblPetName.text = value.name
        getImages(imageArray: value.pictures)
        let mydate1 = value.createdAt
        let dateArr =  mydate1.components(separatedBy: "T")
        let mydate = dateArr[0]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        let date = dateFormatter.date(from: mydate) //according to date format your date string
        let timeTogo = timeAgoSinceDate(date!, currentDate: Date(), numericDates: true)
        lblPetType.text = timeTogo
    }
    
    override func layoutSubviews() {
        
        petImageView.layer.cornerRadius = 10
        petImageView.clipsToBounds = true
        
        circleView.layer.borderWidth = 1
        circleView.layer.borderColor = UIColor.white.cgColor
        
        circleView.layer.cornerRadius = circleView.frame.height/2
        circleView.clipsToBounds = true
        
        
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
        var imageBase = [String]()
        for item in json {
            if let myItem = item.1.string {
                    imageBase.append(myItem)
            }
        }
        if let url = URL(string: imageBase[0]) {
        self.petImageView.sd_setImage(with: url, completed: nil)
        }
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
            
        }

}

class ShelterDetailVC: UIViewController {
    //MARK:- UIControl's Outlets

    @IBOutlet weak var shelterTopImageView: UIImageView!
   // @IBOutlet weak var pageControl: UIPageControl!
   // @IBOutlet weak var animalDetailCollectionView: UICollectionView!
    @IBOutlet weak var sheltetPetCollectionView: UICollectionView!

    @IBOutlet weak var favBtnContainerView: UIView!
    @IBOutlet weak var calenderBtnContainerView: UIView!
    @IBOutlet weak var shelterImageView: UIImageView!
    @IBOutlet weak var shelterFavBtnContainerView: UIView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var shelterLikeBtn: UIButton!
    @IBOutlet weak var shlterNameAgain: UILabel!
    
    @IBOutlet weak var lblShelterName: UILabel!
    @IBOutlet weak var lblShelterSub: UILabel!
    @IBOutlet weak var lblShelterDescription: UILabel!
    @IBOutlet weak var lblAdoptionApplication: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnPhone: UIButton!
    @IBOutlet weak var btnApplication: UIButton!

    @IBOutlet weak var btnViewAllPet: UIButton!

    //MARK:- Class Variables
    var petModel: Animal?
    var shelter : Shelter?
    var shelterModel: FavShelterModel?
    var animalClient = [Animal]()
    var currentAnimalClient = [Animal]()
    var petImagesArray = [String]()
    var indexOfCellBeforeDragging:Int = 0
    var shelterLikedId = [String]()
    var selectedShelterIds = [String]()
    var fromFav = false
    var isfromScheduleScreen = false
    var shelterId = ""
    //MARK:- View life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        makeCircle()
    }
    
    
    //MARK:- Custome Methods
    func setupUI(){
        imageContainerView.backgroundColor = UIColor.lightGray
        if fromFav == false {
        if let pet = petModel {
            fetchAllShelterLikes()
            if shelterLikedId.contains(pet.shelter.shelterId){
                shelterLikeBtn.setImage(UIImage(named:"liked"), for: .normal)
            }
            lblShelterName.text = pet.shelter.name
            lblShelterSub.text = pet.shelter.name
            lblEmail.text = pet.shelter.email
            lblPhoneNumber.text = pet.shelter.phoneNumber
            shelterInfo(id: pet.shelter.shelterId)
            getImages(imageArray: pet.shelter.pictures)
            getAnimalClient(shelterId: pet.shelter.shelterId)
        }
        }else {
            fetchAllShelterLikes()
            if shelterLikedId.contains(shelter!.shelterId){
                shelterLikeBtn.setImage(UIImage(named:"liked"), for: .normal)
            }
            lblShelterName.text = shelter!.name
            lblShelterSub.text = shelter!.name
            lblEmail.text = shelter!.email
            lblPhoneNumber.text = shelter!.phoneNumber
            lblShelterDescription.text = shelter!.description
            getImages(imageArray:shelter!.pictures)
            getAnimalClient(shelterId: shelter!.shelterId)
        }
      
        if isfromScheduleScreen == true {
            shelterInfo(id: self.shelterId)
            getAnimalClient(shelterId:shelterId)
            fetchAllShelterLikes()
            if shelterLikedId.contains(shelterId){
                shelterLikeBtn.setImage(UIImage(named:"liked"), for: .normal)
            }
        }
        
        
    }
    
    func makeCircle(){
        
            favBtnContainerView.layer.cornerRadius = favBtnContainerView.frame.height/2
            favBtnContainerView.clipsToBounds = true
        
            shelterFavBtnContainerView.layer.cornerRadius = shelterFavBtnContainerView.frame.height/2
            shelterFavBtnContainerView.clipsToBounds = true
            
            imageContainerView.layer.cornerRadius = imageContainerView.frame.height/2
            imageContainerView.clipsToBounds = true
        
            shelterImageView.layer.cornerRadius = shelterImageView.frame.height/2
            shelterImageView.clipsToBounds = true
        
            btnViewAllPet.layer.borderWidth = 1
            btnViewAllPet.layer.borderColor = UIColor(rgb: 0xB80CC9).cgColor
            btnViewAllPet.layer.cornerRadius = btnViewAllPet.frame.height/2
            btnViewAllPet.clipsToBounds = true
    }
    
   
    //MARK:- Action Methods

    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        if self.shelterLikedId.contains(petModel!.shelter.shelterId) {
            shelterLikeBtn.setImage(UIImage(named:"like"), for: .normal)
            selectedShelterIds.removeAll { $0 == "\(petModel!.shelter.shelterId)" }
            shelterLikedId.removeAll { $0 == "\(petModel!.shelter.shelterId)" }
            Shelterlike(Ids: selectedShelterIds)
            
        }else {
            shelterLikeBtn.setImage(UIImage(named:"liked"), for: .normal)
            selectedShelterIds.append(petModel!.shelter.shelterId)
            shelterLikedId.append(petModel!.shelter.shelterId)
            Shelterlike(Ids: selectedShelterIds)
        }    }
        
    @IBAction func scheduleButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func showMoreButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            lblShelterDescription.numberOfLines = 0
        }else{
            lblShelterDescription.numberOfLines = 6
        }
        
    }
    
    @IBAction func emailButtonAction(_ sender: UIButton) {
        if let email = lblEmail.text {
            if let url = URL(string: "mailto://\(email)"),
              UIApplication.shared.canOpenURL(url) {
               UIApplication.shared.open(url, options: [:], completionHandler:nil)
              } else {
                 // add error message here
              }
        }
        
    }
    
    @IBAction func phoneButtonAction(_ sender: UIButton) {
        if let phone = lblPhoneNumber.text {
            let realPhoneTex = phone.replacingOccurrences( of:"[^0-9]", with: "", options: .regularExpression)
            if let url = URL(string: "tel://\(realPhoneTex)"),
              UIApplication.shared.canOpenURL(url) {
               UIApplication.shared.open(url, options: [:], completionHandler:nil)
              } else {
                 // add error message here
              }
        }
        
    }
    
    @IBAction func applicationButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func viewAllPetButtonAction(_ sender: UIButton) {
        
    }
  
}


extension ShelterDetailVC: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == sheltetPetCollectionView {
            return currentAnimalClient.count
        }else{
            return petImagesArray.count
        }

      }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == sheltetPetCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShelterPetCollectionVC", for: indexPath) as! ShelterPetCollectionVC
            let image = currentAnimalClient[indexPath.row]
            cell.setValues(value: image)

            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimalDetailCollectionViewCell", for: indexPath) as! AnimalDetailCollectionViewCell
            if let url = URL(string: petImagesArray[indexPath.row]){
                cell.animalImageView.sd_setImage(with: url, completed: nil)
            }
            
            return cell
        }
        

      }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == sheltetPetCollectionView {
            let index = currentAnimalClient[indexPath.row]
            let vc = storyboard?.instantiateViewController(identifier: "MySelectedAnimalVC") as! MySelectedAnimalVC
            vc.petModel = index
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ShelterDetailVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       // if collectionView == sheltetPetCollectionView {
            return CGSize(width: (self.view.frame.size.width - 25)/2.5, height: sheltetPetCollectionView.frame.size.height)
//        }else{
//            return CGSize(width: animalDetailCollectionView.frame.size.width, height: animalDetailCollectionView.frame.size.height)
//        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == sheltetPetCollectionView {
            return 10
        }else{
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
extension ShelterDetailVC {
 
    func shelterInfo(id:String){
        Alamofire.request("https://petsupportapp.com/api/shelters/client/detail/\(id)", method: .get ).responseJSON { (response) in
            if response.result.isSuccess {
                let data:JSON = JSON(response.result.value!)
                self.parseShelterInfo(json: data)
            }
        }
    }
    func parseShelterInfo(json:JSON){
        self.lblShelterDescription.text = json["description"].string ?? ""
        self.lblPhoneNumber.text = json["phoneNumber"].string ?? ""
        self.lblEmail.text = json["email"].string ?? ""
        self.lblShelterName.text = json["name"].string ?? ""
        self.lblShelterSub.text = json["name"].string ?? ""
        self.shlterNameAgain.text = json["name"].string ?? ""
        
        var image = [String]()
        let jsonImage = json["pictures"].array ?? []
        for images in jsonImage {
            image.append(images.string ?? "")
        }
        getImages(imageArray: image)
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
        petImagesArray.removeAll()
        for item in json {
            if let myItem = item.1.string {
                    self.petImagesArray.append(myItem)
            }
        }
       
        self.sheltetPetCollectionView.reloadData()
        if petImagesArray.count > 0 {
        if let url = URL(string: petImagesArray[0]){
        shelterImageView.sd_setImage(with: url, completed: nil)
            shelterTopImageView.sd_setImage(with: url, completed: nil)
           }
        }
    }
    //SHELTER
    func fetchAllShelterLikes(){
        Alamofire.request("https://petsupportapp.com/api/clients/favourite/shelters/\(USER_ID)", method: .get).responseJSON { (reponse) in
            if reponse.result.isSuccess {
                KRProgressHUD.show()
                let data:JSON = JSON(reponse.result.value!)
                print(data)
                self.parseShelterLikes(json:data["favouriteShelters"])
            }else {
                KRProgressHUD.dismiss()
                print(reponse.result.error!.localizedDescription)
            }
        }
    }
    func parseShelterLikes(json:JSON){
        shelterLikedId.removeAll()
        for item in json {
            let id = item.1.string ?? ""
            self.shelterLikedId.append(id)
        }
        selectedShelterIds = shelterLikedId
        if let shelter = shelter {
        if selectedShelterIds.contains(shelter.shelterId){
            shelterLikeBtn.setImage(UIImage(named: "liked"), for: .normal)
          }
        }
        KRProgressHUD.dismiss()
    }
    
    func Shelterlike(Ids:[String]){
        KRProgressHUD.show()
        let petsId = self.selectedShelterIds.removeDuplicates()
        let params : [String : Any] = ["favouriteShelters":petsId]
        Alamofire.request("https://petsupportapp.com/api/clients/favourite/shelters/update/\(USER_ID)", method: .post,parameters: params).responseJSON { (reponse) in
            if reponse.result.isSuccess {
                let data:JSON = JSON(reponse.result.value!)
                print(data)
                KRProgressHUD.dismiss()
            }else {
                KRProgressHUD.dismiss()
                print(reponse.result.error!.localizedDescription)
            }
        }
    }
    func getAnimalClient(shelterId:String){
        KRProgressHUD.show()
        Alamofire.request("https://petsupportapp.com/api/animals/client/shelter/\(shelterId)", method: .get).responseJSON { (reponse) in
            if reponse.result.isSuccess {
                KRProgressHUD.show()
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
            let shelterPictuers = [String]()
            let data = Animal(name: name, type: type, breed: breed, gender: gender, age: age, size: size, personalities: personalities, description: description, id: id, isNeutered: isNeutered, isVaccinated: isVaccinated, isPottyTrained: isPottyTrained, isLeashTrained: isLeashTrained, isAvailable: isAvailable, isAdobted: isAdobted, isScheduled: isScheduled, pictures: animalPicture, createdAt: createdAt,shelter: Shelter(name: shelterName, email: email, phoneNumber: phoneNum, address: streetAdd, city: city, province: province, postalCode: postalCode, pictures: shelterPictuers, shelterId: shelterId, description: ""))
            self.animalClient.append(data)
        }
        self.currentAnimalClient = self.animalClient.reversed()
        self.sheltetPetCollectionView.reloadData()
        KRProgressHUD.dismiss()
        
    }
    

}
/*
extension ShelterDetailVC:UIScrollViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == animalDetailCollectionView {
            let pageWidth = animalDetailCollectionView.frame.width
            let offset = animalDetailCollectionView.contentOffset.x / pageWidth
            indexOfCellBeforeDragging = Int(round(offset))
        }      
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == animalDetailCollectionView {
        
        targetContentOffset.pointee = scrollView.contentOffset
        let pageWidth = animalDetailCollectionView.frame.width
        let collectionViewTotalItem = Int(petModel?.petImages.count ?? 0)
        let offset = animalDetailCollectionView.contentOffset.x / pageWidth
        let indexOfMajorCell = Int(round(offset))
        let swipeVelocityThreshold: CGFloat = 0.5
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < collectionViewTotalItem && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)

        if didUseSwipeToSkipCell {
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = pageWidth * CGFloat(snapToIndex)
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: velocity.x,
                options: .allowUserInteraction,
                animations: {
                    scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                    scrollView.layoutIfNeeded()
                },
                completion: nil
            )
        } else {
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            animalDetailCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
    }
}
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.animalDetailCollectionView {
            var contentOffset = scrollView.contentOffset
            if let contentOffsetX = self.animalDetailCollectionView?.contentInset.left {
                contentOffset.x = contentOffset.x - contentOffsetX
                self.animalDetailCollectionView?.contentOffset = contentOffset

                pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)

            }else{
            }
        }
    }
}*/

