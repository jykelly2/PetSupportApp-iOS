//
//  ShelterDetailVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/10/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit



class ShelterPetCollectionVC: UICollectionViewCell {
    
    @IBOutlet weak var lblPetType: UILabel!
    @IBOutlet weak var lblPetName: UILabel!
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var circleView: UIView!
    
    override func layoutSubviews() {
        
        petImageView.layer.cornerRadius = 10
        petImageView.clipsToBounds = true
        
        circleView.layer.borderWidth = 1
        circleView.layer.borderColor = UIColor.white.cgColor
        
        circleView.layer.cornerRadius = circleView.frame.height/2
        circleView.clipsToBounds = true
        
        
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
    var petModel: PetModel?
    var shelterModel: FavShelterModel?

    var indexOfCellBeforeDragging:Int = 0

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
//        if let _pet = petModel,let petImageName = _pet.petImages.first {
//            lblShelterName.text = _pet.petName
//
//           // pageControl.currentPage = 0
//           // pageControl.numberOfPages = _pet.petImages.count
//        }
        
        if let _shelterModel = shelterModel {
            lblShelterName.text = _shelterModel.shelterName
            shelterTopImageView.image = UIImage(named: _shelterModel.shelterImage)

        }
        
        
    }
    
    func makeCircle(){
        
            favBtnContainerView.layer.cornerRadius = favBtnContainerView.frame.height/2
            favBtnContainerView.clipsToBounds = true
        
            calenderBtnContainerView.layer.cornerRadius = calenderBtnContainerView.frame.height/2
            calenderBtnContainerView.clipsToBounds = true
                        
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
        
    }
        
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
            return 5
        }else{
            return petModel?.petImages.count ?? 0
        }

      }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == sheltetPetCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShelterPetCollectionVC", for: indexPath) as! ShelterPetCollectionVC
            cell.petImageView.image = UIImage(named: "pet1")
            cell.lblPetName.text = "Nahla"
            cell.lblPetType.text = "NEW"

            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimalDetailCollectionViewCell", for: indexPath) as! AnimalDetailCollectionViewCell
            let imageName = petModel?.petImages[indexPath.row]
            cell.animalImageView.image = UIImage(named: imageName!)

            return cell
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

