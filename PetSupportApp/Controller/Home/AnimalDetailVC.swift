//
//  AnimalDetailVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/8/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD

class AnimalDetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var animalImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
            
        }

}

class AnimalDetailVC: UIViewController {
    //MARK:- UIControl's Outlets

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var animalDetailCollectionView: UICollectionView!
    @IBOutlet weak var favBtnContainerView: UIView!
    @IBOutlet weak var shelterFavBtnContainerView: UIView!
    @IBOutlet weak var calenderBtnContainerView: UIView!
    @IBOutlet weak var shelterImageView: UIImageView!
    @IBOutlet weak var petProfileImageView: UIImageView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var btnSeeShelterDetails: UIButton!
    @IBOutlet weak var btnSeeSimilarPet: UIButton!
    @IBOutlet weak var shelterLikeBtn: UIButton!
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
    @IBOutlet weak var lblShelterName:UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPetsLike : UILabel!
    @IBOutlet weak var lblPetsInfo : UILabel!

    @IBOutlet weak var lblMeetPet: UILabel!
    //MARK:- Class Variables
    var petImagesArray = [String]()
    var petModel: Animal?
    var indexOfCellBeforeDragging:Int = 0
    var animalSelectedId = [String]()
    var animalLikedIds = [String]()
    var shelterLikedId = [String]()
    var selectedShelterIds = [String]()
    
    //MARK:- View life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    override func viewDidLayoutSubviews() {
        makeCircle()
    }
    
    //MARK:- Custome Methods
    func setupUI(){
        imageContainerView.backgroundColor = UIColor.lightGray
        if let pet = petModel{
            
            fetchAllShelterLikes()
            
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
            
           //Shelter info update
            lblShelterName.text = pet.shelter.name
            lblLocation.text = "\(pet.shelter.address), \(pet.shelter.postalCode), \(pet.shelter.city), \(pet.shelter.province)"
            lblEmail.text = pet.shelter.email
            lblPetsLike.text = "Pets like \(pet.name)"
            lblPetsInfo.text = "Undecided? See other pets like \(pet.name) that also need a home"
        }
    }
    
    func makeCircle(){
        
            favBtnContainerView.layer.cornerRadius = favBtnContainerView.frame.height/2
            favBtnContainerView.clipsToBounds = true
        
            calenderBtnContainerView.layer.cornerRadius = calenderBtnContainerView.frame.height/2
            calenderBtnContainerView.clipsToBounds = true
            
            petProfileImageView.layer.cornerRadius = petProfileImageView.frame.height/2
            petProfileImageView.clipsToBounds = true
           
            shelterFavBtnContainerView.layer.cornerRadius = shelterFavBtnContainerView.frame.height/2
            shelterFavBtnContainerView.clipsToBounds = true
            
            imageContainerView.layer.cornerRadius = imageContainerView.frame.height/2
            imageContainerView.clipsToBounds = true
        
            shelterImageView.layer.cornerRadius = shelterImageView.frame.height/2
            shelterImageView.clipsToBounds = true
            
            btnSeeShelterDetails.layer.cornerRadius = btnSeeShelterDetails.frame.height/2
            btnSeeShelterDetails.clipsToBounds = true
            
            btnSeeSimilarPet.layer.cornerRadius = btnSeeSimilarPet.frame.height/2
            btnSeeSimilarPet.clipsToBounds = true
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
    @IBAction func shelterFavBtnAction(_ sender: Any) {
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
    
    @IBAction func seeSimilarLookingPetButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func seeShelterDetailButtonAction(_ sender: UIButton) {
        let vc = SHome.instantiateViewController(withIdentifier: "ShelterDetailVC") as! ShelterDetailVC
        //vc.hidesBottomBarWhenPushed = true
        //anish
        vc.petModel = petModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension AnimalDetailVC: UICollectionViewDelegate,UICollectionViewDataSource{
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

extension AnimalDetailVC: UICollectionViewDelegateFlowLayout {
    
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

extension AnimalDetailVC:UIScrollViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let pageWidth = animalDetailCollectionView.frame.width
        let offset = animalDetailCollectionView.contentOffset.x / pageWidth
        indexOfCellBeforeDragging = Int(round(offset))
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        let pageWidth = animalDetailCollectionView.frame.width
        //anish 
        let collectionViewTotalItem = Int(10 ?? 0)
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

extension AnimalDetailVC:OptionVCDelegate{
    func didSelectOption(_ controller: OptionVC, optionname: String) {
        let vc = SHome.instantiateViewController(withIdentifier: "CreateScheduleModalVC") as! CreateScheduleModalVC
        self.addChild(vc)
        vc.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
}

extension AnimalDetailVC {
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
    
    //SHELTER
    func fetchAllShelterLikes(){
        Alamofire.request("https://petsupportapp.com/api/clients/favourite/shelters/\(USER_ID)", method: .get).responseJSON { (reponse) in
            if reponse.result.isSuccess {
                KRProgressHUD.show()
                let data:JSON = JSON(reponse.result.value!)
                print(data)
                self.parseShelterLikes(json:data["favouriteShelters"])
            }else {
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
        if selectedShelterIds.contains(petModel!.shelter.shelterId){
            shelterLikeBtn.setImage(UIImage(named: "liked"), for: .normal)
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
                print(reponse.result.error!.localizedDescription)
            }
        }
    }
}
