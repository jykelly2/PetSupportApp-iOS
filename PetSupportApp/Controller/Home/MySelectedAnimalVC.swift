//
//  MySelectedAnimalVC.swift
//  PetSupportApp
//
//  Created by Anish on 9/23/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD

class MySelectedAnimalVC: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var animalDetailCollectionView: UICollectionView!
    @IBOutlet weak var favBtnContainerView: UIView!
    @IBOutlet weak var calenderBtnContainerView: UIView!
    @IBOutlet weak var petProfileImageView: UIImageView!
    @IBOutlet weak var petLikeBtn: UIButton!
    @IBOutlet weak var lblAnimalName: UILabel!
    @IBOutlet weak var lblAnimalSubTitle: UILabel!
    @IBOutlet weak var lblAnimalType: UILabel!
    @IBOutlet weak var lblAnimalWeight: UILabel!
    @IBOutlet weak var lblAnimalGender: UILabel!
    @IBOutlet weak var lblAnimalAge: UILabel!
    @IBOutlet weak var lblSpayed: UILabel!
    @IBOutlet weak var lblVaccination: UILabel!
    @IBOutlet weak var lblHouseTrained: UILabel!
    @IBOutlet weak var lblPottyTrained: UILabel!
    @IBOutlet weak var lblLeashTrained: UILabel!
    @IBOutlet weak var lblAnimalDescription: UILabel!
    @IBOutlet weak var lblMeetPet: UILabel!
    
    var petImagesArray = [String]()
    var petModel: Animal?
    var indexOfCellBeforeDragging:Int = 0
    var animalSelectedId = [String]()
    var animalLikedIds = [String]()
    var fromScheduleScreen = false
    var animailId = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        setupUI()
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewDidLayoutSubviews() {
        makeCircle()
    }
    
    //MARK:- Custome Methods
    func setupUI(){
        if let pet = petModel{
            if animalLikedIds.contains(pet.id){
                petLikeBtn.setImage(UIImage(named: "liked"), for: .normal)
            }
            
           // petProfileImageView.image = UIImage(named: "\(petImageName)")
            lblAnimalName.text = pet.name
            lblMeetPet.text = "Meet \(pet.name)"
            lblAnimalSubTitle.text = "\(pet.breed)"
            lblAnimalType.text = "\(pet.breed)"
            lblAnimalWeight.text = pet.size
            lblAnimalGender.text = pet.gender
            lblAnimalAge.text = "\(pet.age) years old"
            lblAnimalDescription.text = pet.description
            getImages(imageArray:pet.pictures)
            if pet.isNeutered == true {
                lblSpayed.text = "Spayed/Neutered"
            }else{
                lblSpayed.text = "Not Spayed/Neutered"
            }
            if pet.isVaccinated == true {
                lblVaccination.text = "Vaccinations up-to-date"
            }else {
                lblVaccination.text = "Not Vaccinated"
            }
            if pet.isPottyTrained == true {
                lblPottyTrained.text = "Potty Trained"
            }else {
                lblPottyTrained.text = "Not Potty Trained"
            }
            if pet.isLeashTrained == true {
                lblLeashTrained.text = "Leash Trained"
            }else{
                lblLeashTrained.text = "Not Leash Trained"
            }
            pageControl.currentPage = 0
            pageControl.numberOfPages = 4
            
        }else {
            print(self.fromScheduleScreen)
            self.fetchAllPetsLikes()
            self.getAnimalFromId(id: self.animailId)
        }
    }
    
    func makeCircle(){
        
            favBtnContainerView.layer.cornerRadius = favBtnContainerView.frame.height/2
            favBtnContainerView.clipsToBounds = true
        
            petProfileImageView.layer.cornerRadius = petProfileImageView.frame.height/2
            petProfileImageView.clipsToBounds = true
    }
    
   
    //MARK:- Action Methods

    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func optionButtonAction(_ sender: UIButton) {
        
        let vc = SHome.instantiateViewController(withIdentifier: "OptionVC") as! OptionVC
        self.addChild(vc)
        vc.delegate = self
        //anish
     //   vc.petModel = petModel
        vc.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
        
    }
    
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        if self.animalLikedIds.contains(petModel!.id) {
            petLikeBtn.setImage(UIImage(named:"like"), for: .normal)
            animalSelectedId.removeAll { $0 == "\(petModel!.id)" }
            animalLikedIds.removeAll { $0 == "\(petModel!.id)" }
            like(petId: animalSelectedId)
            
        }else {
            petLikeBtn.setImage(UIImage(named:"liked"), for: .normal)
            animalSelectedId.append(petModel!.id)
            animalLikedIds.append(petModel!.id)
            like(petId: animalSelectedId)
        }

        
    }
    
    @IBAction func scheduleButtonAction(_ sender: UIButton) {
        
        let vc = SHome.instantiateViewController(withIdentifier: "CreateScheduleModalVC") as! CreateScheduleModalVC
        self.addChild(vc)
        vc.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
        
    }
    
    @IBAction func showMoreButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            lblAnimalDescription.numberOfLines = 0
        }else{
            lblAnimalDescription.numberOfLines = 6
        }
    }

}
extension MySelectedAnimalVC:OptionVCDelegate{
    func didSelectOption(_ controller: OptionVC, optionname: String) {
        let vc = SHome.instantiateViewController(withIdentifier: "CreateScheduleModalVC") as! CreateScheduleModalVC
        self.addChild(vc)
        vc.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
}

extension MySelectedAnimalVC: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return petImagesArray.count

      }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimalDetailCollectionViewCell", for: indexPath) as! AnimalDetailCollectionViewCell
        let imageName = petImagesArray[indexPath.row]
        if let url = URL(string: imageName){
            cell.animalImageView.sd_setImage(with: url, completed: nil)
        }
        

        return cell

      }
}

extension MySelectedAnimalVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: animalDetailCollectionView.frame.size.width, height: animalDetailCollectionView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
extension MySelectedAnimalVC {
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
        petImagesArray.removeAll()
        for item in json {
            if let myItem = item.1.string {
                    self.petImagesArray.append(myItem)
            }
        }
        self.animalDetailCollectionView.dataSource = self
        self.animalDetailCollectionView.delegate = self
        self.animalDetailCollectionView.reloadData()
    }
    
    func fetchAllPetsLikes(){
        Alamofire.request("https://petsupportapp.com/api/clients/favourite/pets/\(USER_ID)", method: .get).responseJSON { (reponse) in
            if reponse.result.isSuccess {
                KRProgressHUD.show()
                let data:JSON = JSON(reponse.result.value!)
                print(data)
                self.parseLikes(json:data["favouritePets"])
            }else {
                KRProgressHUD.dismiss()
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
        KRProgressHUD.dismiss()
    }
    
    func like(petId:[String]){
        KRProgressHUD.show()
        let petsId = self.animalSelectedId.removeDuplicates()
        let params : [String : Any] = ["favouritePets":petsId]
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
    
    //IF USER IS COMING FROM ONLY PET ID
    
    func getAnimalFromId(id:String) {
        Alamofire.request("https://petsupportapp.com/api/animals/client/detail/\(id)", method: .get).responseJSON { (response) in
            if response.result.isSuccess {
                let data:JSON = JSON(response.result.value!)
                print(data)
                self.parseAnimalData(json: data)
            }
        }
    }
    func parseAnimalData(json:JSON){
   //     for item in json {
            let name = json["name"].string ?? ""
            let type = json["animalType"].string ?? ""
            let breed = json["breed"].string ?? ""
            let gender = json["gender"].string ?? ""
            let age = json["age"].int ?? 0
            let size = json["size"].string ?? ""
            var personalities = [String]()
            let personalitiesArray = json["personalities"].array
            for item in personalitiesArray! {
                personalities.append(item.string ?? "")
            }
            let description = json["description"].string ?? ""
            let id = json["_id"].string ?? ""
            let createdAt = json["createdAt"].string ?? ""
            
            let isNeutered = json["isNeuteured"].bool ?? false
            let isVaccinated = json["isVaccinated"].bool ?? false
            let isPottyTrained = json["isPottyTrained"].bool ?? false
            let isLeashTrained = json["isLeashTrained"].bool ?? false
            let isAvailable = json["isAvailable"].bool ?? false
            let isAdobted = json["isAdopted"].bool ?? false
            let isScheduled = json["isScheduled"].bool ?? false
            var animalPicture = [String]()
            let pictures = json["pictures"].array
            for item in pictures! {
                animalPicture.append(item.string ?? "")
            //    getImages(imageArray:item.string ?? "")
            }
            lblAnimalName.text = name
            lblMeetPet.text = "Meet \(name)"
            lblAnimalSubTitle.text = "\(breed)"
            lblAnimalType.text = "\(breed)"
            lblAnimalWeight.text = size
            lblAnimalGender.text = gender
            lblAnimalAge.text = "\(age) years old"
            lblAnimalDescription.text = description
            getImages(imageArray:animalPicture)
            if isNeutered == true {
                lblSpayed.text = "Spayed/Neutered"
            }else{
                lblSpayed.text = "Not Spayed/Neutered"
            }
            if isVaccinated == true {
                lblVaccination.text = "Vaccinations up-to-date"
            }else {
                lblVaccination.text = "Not Vaccinated"
            }
            if isPottyTrained == true {
                lblPottyTrained.text = "Potty Trained"
            }else {
                lblPottyTrained.text = "Not Potty Trained"
            }
            if isLeashTrained == true {
                lblLeashTrained.text = "Leash Trained"
            }else{
                lblLeashTrained.text = "Not Leash Trained"
            }
             if animalLikedIds.contains(id){
            petLikeBtn.setImage(UIImage(named: "liked"), for: .normal)
             }
            /*
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
 */
            
       // }
    }
    
}
extension MySelectedAnimalVC:UIScrollViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let pageWidth = animalDetailCollectionView.frame.width
        let offset = animalDetailCollectionView.contentOffset.x / pageWidth
        indexOfCellBeforeDragging = Int(round(offset))
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        let pageWidth = animalDetailCollectionView.frame.width
        //anish
        let collectionViewTotalItem = Int(10)
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
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.animalDetailCollectionView {
            var contentOffset = scrollView.contentOffset
            if let contentOffsetX = self.animalDetailCollectionView?.contentInset.left {
                contentOffset.x = contentOffset.x - contentOffsetX
                self.animalDetailCollectionView?.contentOffset = contentOffset

                pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)

            }else{
                print("Test-test")
            }
        }
    }
}
