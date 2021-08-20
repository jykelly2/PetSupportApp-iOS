//
//  AnimalDetailVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/8/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

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
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblEmail: UILabel!

    @IBOutlet weak var lblMeetPet: UILabel!
    //MARK:- Class Variables
    var petModel: PetModel?
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
        if let _pet = petModel,let petImageName = _pet.petImages.first {
            petProfileImageView.image = UIImage(named: "\(petImageName)")
            lblAnimalName.text = _pet.petName
            lblMeetPet.text = "Meet \(_pet.petName)"

            pageControl.currentPage = 0
            pageControl.numberOfPages = _pet.petImages.count
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
        
        let vc = SMain.instantiateViewController(withIdentifier: "OptionVC") as! OptionVC
        self.addChild(vc)
        vc.delegate = self
        vc.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
        
    }
    
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        
    }
        
    @IBAction func scheduleButtonAction(_ sender: UIButton) {
        
        let vc = SMain.instantiateViewController(withIdentifier: "CreateScheduleModalVC") as! CreateScheduleModalVC
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
        let vc = SMain.instantiateViewController(withIdentifier: "ShelterDetailVC") as! ShelterDetailVC
        //vc.hidesBottomBarWhenPushed = true
        vc.petModel = petModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension AnimalDetailVC: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return petModel?.petImages.count ?? 0

      }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimalDetailCollectionViewCell", for: indexPath) as! AnimalDetailCollectionViewCell
        let imageName = petModel?.petImages[indexPath.row]
        cell.animalImageView.image = UIImage(named: imageName!)

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
        let vc = SMain.instantiateViewController(withIdentifier: "CreateScheduleModalVC") as! CreateScheduleModalVC
        self.addChild(vc)
        vc.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }    
}

