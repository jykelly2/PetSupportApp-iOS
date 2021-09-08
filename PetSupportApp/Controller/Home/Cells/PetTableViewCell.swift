//
//  PetTableViewCell.swift
//  PetSupportApp
//
//  Created by Anish on 9/7/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

protocol PetTableViewCellDelegate {
    func didSelectItem(_ petModel: Animal?)
}
class PetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblPetName: UILabel!
    @IBOutlet weak var lblPetTypeAndDistance: UILabel!
    @IBOutlet weak var lblHehavior: UILabel!
    @IBOutlet weak var btnViewProfile: UIButton!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    
    @IBOutlet weak var petCollectionView: UICollectionView!
    @IBOutlet weak var pagingView: UIPageControl!
    
    var delegate: PetTableViewCellDelegate!
    var indexOfCellBeforeDragging:Int = 0
    var petImages:[String] = []
    var animalClient : Animal? = nil
    var imageBase64Data = [String]()
    
    func setValues(values:Animal){
        animalClient = values
        self.lblPetName.text = values.name
        self.lblPetTypeAndDistance.text = "\(values.type)  •   \(values.breed)   •   87 mi away"
        self.lblHehavior.text = values.personalities[1]
        getImages(imageArray: values.pictures)
      
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCollectionView()
    }
    
    func resetCollectionView() {
        guard petImages.count <= 0 else { return }
        petImages = []
        petCollectionView.reloadData()
    }
    
    override func layoutSubviews() {
        
        containerView.layer.cornerRadius = 5
        containerView.clipsToBounds = true
        
        lblHehavior.layer.cornerRadius = lblHehavior.frame.height/2
        lblHehavior.clipsToBounds = true
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
           
        
    }
    
}
extension PetTableViewCell:UIScrollViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let pageWidth = petCollectionView.frame.width
        let offset = petCollectionView.contentOffset.x / pageWidth
        indexOfCellBeforeDragging = Int(round(offset))
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        let pageWidth = petCollectionView.frame.width
        let collectionViewTotalItem = Int(10)
        let offset = petCollectionView.contentOffset.x / pageWidth
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
            petCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.petCollectionView {
            var contentOffset = scrollView.contentOffset
            if let contentOffsetX = self.petCollectionView?.contentInset.left {
                contentOffset.x = contentOffset.x - contentOffsetX
                self.petCollectionView?.contentOffset = contentOffset
                
                pagingView.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
                
            }else{
                print("Test-test")
            }
        }
    }
}

extension PetTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
       
        return imageBase64Data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = imageBase64Data[indexPath.row]
        let cell = petCollectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! PetsCollectionViewCell
        
        if  imageBase64Data.count > indexPath.row {
            
            if let url = URL(string: data){
                cell.petImageView.sd_setImage(with: url, completed: nil)
            }
            
            cell.lblPetType.text = animalClient?.name
        }
        
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate.didSelectItem(animalClient)
    }
}

extension PetTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: petCollectionView.frame.size.width, height: petCollectionView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension PetTableViewCell {
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
        imageBase64Data.removeAll()
        for item in json {
            if let myItem = item.1.string {
                    self.imageBase64Data.append(myItem)
            }
        }
        self.petCollectionView.dataSource = self
        self.petCollectionView.delegate = self
        self.petCollectionView.reloadData()
    }
}
