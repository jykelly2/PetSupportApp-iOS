//
//  SortModalVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/12/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

@objc protocol SortModalVCDelegate {
    @objc func didSelectSortItem(_ sortedBy: String)
}

class SortModalVC: UIViewController {
    //MARK:- UIControl's Outlets
    
    @IBOutlet weak var lblHeader : UILabel!
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var btnClose : UIButton!
  
    @IBOutlet weak var btnSortByFuthest: UIButton!
    @IBOutlet weak var btnSortByRandom: UIButton!
    @IBOutlet weak var btnSortByNearest: UIButton!
    @IBOutlet weak var btnSortByOldest: UIButton!
    @IBOutlet weak var btnSortByNewest: UIButton!
    @IBOutlet private var optionContainerVw: UIView!

    //MARK:- Class Variables
    weak var delegate: SortModalVCDelegate?
    var optionBtnArray:[UIButton] = []
    var selectedItem = ""
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    override func viewDidLayoutSubviews() {
        makeRoundView()
    }
    
    func makeRoundView(){
        btnClose.layer.cornerRadius = btnClose.frame.height/2
        btnClose.clipsToBounds = true
        
        optionContainerVw.layer.cornerRadius = 10
        optionContainerVw.clipsToBounds = true
        optionContainerVw.layer.borderWidth = 1
        optionContainerVw.layer.borderColor = UIColor.black.cgColor
        
    }
   
    
    //MARK:- Custome Methods
    
    func configureUI(){
        //self.mainView.alpha = 0.0
        optionBtnArray = [btnSortByNewest,btnSortByOldest,btnSortByNearest,btnSortByFuthest,btnSortByRandom]
        for btn in optionBtnArray {
            if FilterItems.shared.isAlreadySortedItemSelected(btn.titleLabel?.text ?? "") {
                btn.backgroundColor = UIColor.init(rgb: 0x6e0b9c)
                btn.setTitleColor(.white, for: .normal)
                btn.isSelected = true
            }
           
        }

        self.view.backgroundColor = .clear
        self.presentAnimation()
    }

    func presentAnimation(){
        
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    func dismissAnimation(){
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }) { (finished : Bool) in
            if (finished){
                self.view.removeFromSuperview()
            }
        }
    }
    
    //MARK:- Action Methods
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.delegate?.didSelectSortItem(self.selectedItem)
        self.dismissAnimation()
    }
    
    @IBAction func sortByAction(_ sender: UIButton) {
        for btn in optionBtnArray {
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(.black, for: .normal)
            if btn.isSelected {
                FilterItems.shared.removeSortedItem(btn.titleLabel?.text ?? "")
            }
            btn.isSelected = false
        }
        FilterItems.shared.addSortedItem(sender.titleLabel?.text ?? "")
        sender.isSelected = true
        sender.backgroundColor = UIColor.init(rgb: 0x6e0b9c)
        sender.setTitleColor(.white, for: .normal)
        self.selectedItem = sender.titleLabel?.text ?? ""
    }

}
