//
//  FavoriteVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/13/21.
//  Copyright © 2021 Jun K. All rights reserved.
//


import UIKit

enum FAVORITE_TYPE : String {
    case Pet = "Pets"
    case Shelter = "Shelters"
}

class TopTabModel : NSObject {
    var tilte : String!
    var isSelect : Bool = false
    
    init(tilte : String){
        self.tilte = tilte
    }
}

//----------------------------------------------------------------------------
//MARK:- UICollectionViewCell
//----------------------------------------------------------------------------
class FavColCell: UICollectionViewCell {
    @IBOutlet weak var lblType : UILabel!
    @IBOutlet weak var imgSelection : UIImageView!
    override func awakeFromNib() {
        self.lblType.adjustsFontSizeToFitWidth = true
    }
}

class FavoriteVC: UIViewController {

    //----------------------------------------------------------------------------
    //MARK:- UIControl's Outlets
    
    @IBOutlet weak var colView : UICollectionView!
    @IBOutlet weak var vwPageContainer : UIView!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    var pageViewController : UIPageViewController   = UIPageViewController()
    var selectIndex : Int                           = 0
    var arrViewController : [UIViewController]      = []
    var FavTypeArray : [TopTabModel] = []
    
    
    //----------------------------------------------------------------------------
    //MARK:- Memory management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Custome Methods
        
    func setUpView(){
        //self.title = "My Rides"
        self.configureUI()
        self.setPageViewController()
    }
    
    //Desc:- Set layout desing customize
    
    func configureUI(){
        
    }
    
    func setData(){
        self.FavTypeArray = []
        
        let pet = TopTabModel(tilte: FAVORITE_TYPE.Pet.rawValue)
        pet.isSelect = true
        self.FavTypeArray.append(pet)
        self.FavTypeArray.append(TopTabModel(tilte: FAVORITE_TYPE.Shelter.rawValue))
        self.colView.reloadData()
    }
    
    
    //----------------------------------------------------------------------------
    //MARK:- Action Methods
    
    
    
    //----------------------------------------------------------------------------
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.setData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

}

//----------------------------------------------------------------------------
//MARK:- UICollectionView Method
//----------------------------------------------------------------------------
extension FavoriteVC : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.FavTypeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavColCell", for: indexPath) as! FavColCell
        let obj = self.FavTypeArray[indexPath.row]
        
        
        if obj.isSelect{
           // "Ubuntu-Medium"
            cell.lblType.textColor = UIColor(rgb: 0xB80CC9)
            cell.lblType.font = UIFont.init(name: "HelveticaNeue-Medium", size: 20)
            cell.imgSelection.isHidden = false
        }else{
            cell.lblType.textColor = .black
            cell.lblType.font = UIFont.init(name: "HelveticaNeue", size: 20)
            cell.imgSelection.isHidden = true
        }
        cell.lblType.text = obj.tilte
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let prevIndex = selectIndex
        print("prevIndex: \(prevIndex)")
        selectIndex     = indexPath.item
        print("selectIndex: \(selectIndex)")
        
        self.setViewSelection(index: indexPath.item)
        
        if indexPath.item == 0 {
            self.pageViewController.setViewControllers([self.arrViewController[indexPath.item]], direction: .reverse , animated: true, completion: nil)
        }
        if indexPath.item == 1 {
            if prevIndex == 2 {
                self.pageViewController.setViewControllers([self.arrViewController[indexPath.item]], direction: .reverse , animated: true, completion: nil)
            }
            else {
                self.pageViewController.setViewControllers([self.arrViewController[indexPath.item]], direction: .forward , animated: true, completion: nil)
            }
        }
        else {
            self.pageViewController.setViewControllers([self.arrViewController[indexPath.item]], direction: .forward , animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: self.colView.frame.width / 2, height: self.colView.frame.size.height)
    }
}

extension FavoriteVC{
    
    func setViewSelection(index: Int){
        if self.FavTypeArray.count > 0 {
            let obj = self.FavTypeArray[index]
            self.FavTypeArray  = self.FavTypeArray.filter { (object) -> Bool in
                object.isSelect = false
                if object.tilte == obj.tilte {
                    object.isSelect = true
                    return true
                }
                
                return true
            }
            self.colView.reloadData()
        }
    }
    
    func setPageViewController(){
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController.view.backgroundColor = UIColor.clear
        
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
        let past : FavoritePetListVC = SFavorite.instantiateViewController(withIdentifier: "FavoritePetListVC") as! FavoritePetListVC
       // past.rideType = .Past
        self.arrViewController.append(past)
        
        let schedule : FavoriteShelterListVC = SFavorite.instantiateViewController(withIdentifier: "FavoriteShelterListVC") as! FavoriteShelterListVC
        //schedule.rideType = .Schedule
        self.arrViewController.append(schedule)
        
        self.selectIndex = 0
        self.pageViewController.view.frame = CGRect(x: 0, y: 0, width: self.vwPageContainer.frame.size.width, height: self.vwPageContainer.frame.size.height)
        self.addChild(self.pageViewController)
        self.pageViewController.setViewControllers([self.arrViewController.first!], direction: .forward, animated: true
            , completion: nil)
        self.vwPageContainer.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParent: self)
    }
}

extension FavoriteVC : UIPageViewControllerDelegate , UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        
        guard let viewControllerIndex = arrViewController.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        guard arrViewController.count > previousIndex else {
            return nil
        }
        
        return arrViewController[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        
        guard let viewControllerIndex = arrViewController.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = arrViewController.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return arrViewController[nextIndex]
    }
}
