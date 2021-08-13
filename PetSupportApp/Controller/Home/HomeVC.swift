//
//  HomeVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/8/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

class PetCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblPetType: UILabel!
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var circleView: UIView!
    
    override func layoutSubviews() {
        circleView.layer.borderWidth = 1
        circleView.layer.borderColor = UIColor.white.cgColor
        
        circleView.layer.cornerRadius = circleView.frame.height/2
        circleView.clipsToBounds = true
    }

    override func awakeFromNib() {
        super.awakeFromNib()
            
        }

}

class PetFilterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var downArrowImageView: UIImageView!
    @IBOutlet weak var lblFilterType: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.cornerRadius = 5
        containerView.clipsToBounds = true
    }

}

protocol PetTableViewCellDelegate {
    func didSelectItem(_ petModel: PetModel?)
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

     var petModel: PetModel? {
        didSet{
            if let _petModel = petModel {
                lblPetName.text = _petModel.petName
                pagingView.currentPage = 0
                pagingView.numberOfPages = _petModel.petImages.count
                petImages = _petModel.petImages
            }
        }
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
        self.petCollectionView.dataSource = self
        self.petCollectionView.delegate = self
            
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
        let collectionViewTotalItem = Int(petModel?.petImages.count ?? 0)
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

        return petImages.count

      }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetCollectionViewCell", for: indexPath) as! PetCollectionViewCell
        if  petImages.count > indexPath.row {
            let imageName = petModel?.petImages[indexPath.row]
            cell.petImageView.image = UIImage(named: imageName!)
            cell.lblPetType.text = petModel?.petCollectionType
        }else{
            return UICollectionViewCell()
        }

        return cell

      }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate.didSelectItem(petModel)
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



class HomeVC: UIViewController, BreadModalVCDelegate {
    func didSelectItem(_ isSelect: Bool) {
        if self.filterMasterMenuArray.count > 0 && FilterItems.shared.filterItemArray.count > 0 {
            self.filterMenuArray = []
            self.filterMenuArray.append(contentsOf: FilterItems.shared.filterItemArray)
            self.filterMenuArray.append(contentsOf: self.filterMasterMenuArray)
            self.filterCollectionView.reloadData()
            lblTotalFilter.text = "\(FilterItems.shared.filterItemArray.count)"
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


    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        petTableView.rowHeight = 490
        updateUI()
        setFilterMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
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
    
    
    func goToAnimalDetailVC(_ petModel:PetModel){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AnimalDetailVC") as! AnimalDetailVC
        //vc.hidesBottomBarWhenPushed = true
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
            let destVC:BreadModalVC!  = self.storyboard!.instantiateViewController(withIdentifier: filterMenu.filterModalMenu.rawValue) as? BreadModalVC
            destVC.delegate = self
            self.addChild(destVC)
            destVC.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(destVC.view)
            destVC.didMove(toParent: self)
        default:
            let destVC:UIViewController!  = self.storyboard!.instantiateViewController(withIdentifier: filterMenu.filterModalMenu.rawValue)
            self.addChild(destVC)
            destVC.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(destVC.view)
            destVC.didMove(toParent: self)

           }
        }
        
//        case DistanceModalVC
//        case AgeModalVC
//        case BreadModalVC
//        case SizeModalVC
//        case GoodWithModalVC
//        case ShelterRescueModalVC
//        case ColarModalVC
//        case CoatLengthModalVC
//        case Filter
        
       
    }
    
    
   
    //MARK:- Action Methods
    @IBAction func filterAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
            vc.hidesBottomBarWhenPushed = true
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func mapButtonAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapVC") as! MapVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func sortButtonAction(_ sender: UIButton) {
        let destVC = self.storyboard?.instantiateViewController(withIdentifier: "SortModalVC") as! SortModalVC
        self.addChild(destVC)
        destVC.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(destVC.view)
        destVC.didMove(toParent: self)
    }
    
    
}

//MARK:- UITableViewDelegate,UITableViewDataSource
extension HomeVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.petList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PetTableViewCell") as? PetTableViewCell else { return UITableViewCell() }
        let petModel = viewModel.petList[indexPath.row]
        cell.delegate = self
        cell.petModel = petModel

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let petModel = viewModel.petList[indexPath.row]
        goToAnimalDetailVC(petModel)
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//        if let cell = cell as? PetTableViewCell {
//
//            cell.petCollectionView.dataSource = self
//            cell.petCollectionView.delegate = self
//            cell.petCollectionView.reloadData()
//
//        }
//    }
}

extension HomeVC:PetTableViewCellDelegate{
    func didSelectItem(_ petModel: PetModel?) {
        if let _petModel = petModel {
            goToAnimalDetailVC(_petModel)
        }
    }    
}

//MARK:- UICollectionViewDelegate,UICollectionViewDataSource
extension HomeVC: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return filterMenuArray.count

      }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetFilterCollectionViewCell", for: indexPath) as!
            PetFilterCollectionViewCell
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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
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

