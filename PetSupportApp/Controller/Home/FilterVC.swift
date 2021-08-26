//
//  SearchVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/9/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

@objc protocol FilterVCDelegate {
    @objc func didSelectItem(_ isSelect: Bool)
}

class BreedTableViewCell: UITableViewCell {
    //MARK:- UIControl's Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblPetName: UILabel!
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var btnCheck: UIButton!
    var isCheckSelectedItem = true
    
    
     var breedModel: BreedModel? {
        didSet{
            if var _breedModel = breedModel {
                lblPetName.text = _breedModel.petName
                petImageView.image = UIImage(named: "\(_breedModel.petImage)")
                if isCheckSelectedItem {
                    if FilterItems.shared.isAlreadyItemSelected(_breedModel.petName) {
                        _breedModel.isSelected = true
                    }else{
                        _breedModel.isSelected = false
                    }
                    btnCheck.isSelected = _breedModel.isSelected
                }
             
                btnCheck.setBackgroundImage(UIImage(named: "uncheck_box_icon"), for: .normal)
                btnCheck.setBackgroundImage(UIImage(named: "check_box_icon"), for: .selected)

            }
        }
    }
    
    override func layoutSubviews() {
        petImageView.layer.cornerRadius = petImageView.frame.height/2
        petImageView.clipsToBounds = true
    }
}

class FilterVC: UIViewController {
    //MARK:- UIControl's Outlets
    @IBOutlet private var shortBtnContainerVw: UIView!
    @IBOutlet private var distanceBtnContainerVw: UIView!
    @IBOutlet weak var tblBreed: UITableView!
    @IBOutlet weak var tblShelter: UITableView!
    @IBOutlet weak var tblColor: UITableView!

    @IBOutlet weak var btnSortByFuthest: UIButton!
    @IBOutlet weak var btnSortByRandom: UIButton!
    @IBOutlet weak var btnSortByNearest: UIButton!
    @IBOutlet weak var btnSortByOldest: UIButton!
    @IBOutlet weak var btnSortByNewest: UIButton!
    
    @IBOutlet weak var btnTenMiles: UIButton!
    @IBOutlet weak var btnCustomMiles: UIButton!
    @IBOutlet weak var btnHundredMiles: UIButton!
    @IBOutlet weak var btnFiftyMiles: UIButton!
    @IBOutlet weak var btnTwentyFiveMiles: UIButton!
    
    @IBOutlet weak var btnBaby: UIButton!
    @IBOutlet weak var btnYoung: UIButton!
    @IBOutlet weak var btnAdult: UIButton!
    @IBOutlet weak var btnSenior: UIButton!

    @IBOutlet weak var btnSmallSize: UIButton!
    @IBOutlet weak var btnMediumSize: UIButton!
    @IBOutlet weak var btnLargeSize: UIButton!
    @IBOutlet weak var btnXLSize: UIButton!
    
    @IBOutlet weak var btnGoodWithKids: UIButton!
    @IBOutlet weak var btnGoodWithOtherDogs: UIButton!
    @IBOutlet weak var btnGoodWithCats: UIButton!
    
    @IBOutlet weak var btnhairLess: UIButton!
    @IBOutlet weak var btnShort: UIButton!
    @IBOutlet weak var btnMedium: UIButton!
    @IBOutlet weak var btnLong: UIButton!
    @IBOutlet weak var btnWire: UIButton!
    @IBOutlet weak var btnCurly: UIButton!

    //MARK:- Class Variables
    weak var delegate: FilterVCDelegate?

    var sortBtnArray:[UIButton] = []
    var distanceBtnArray:[UIButton] = []
    var ageOptionBtnArray:[UIButton] = []
    var sizeOptionBtnArray:[UIButton] = []
    var goodWithOptionBtnArray:[UIButton] = []
    var coatOptionBtnArray:[UIButton] = []
    var allOptionBtnArray:[UIButton] = []

    let viewModel = PetViewModel()

    //MARK:- View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        self.makeRound()
    }
    
    //MARK:- Custome Methods
    
    func makeRound(){
        
        shortBtnContainerVw.layer.cornerRadius = 10
        shortBtnContainerVw.clipsToBounds = true
        shortBtnContainerVw.layer.borderWidth = 1
        shortBtnContainerVw.layer.borderColor = UIColor.black.cgColor
        
        distanceBtnContainerVw.layer.cornerRadius = 10
        distanceBtnContainerVw.clipsToBounds = true
        distanceBtnContainerVw.layer.borderWidth = 1
        distanceBtnContainerVw.layer.borderColor = UIColor.black.cgColor
        
        btnBaby.layer.cornerRadius = 10
        btnBaby.clipsToBounds = true
        btnBaby.layer.borderWidth = 1
        btnBaby.layer.borderColor = UIColor.lightGray.cgColor
        
        btnYoung.layer.cornerRadius = 10
        btnYoung.clipsToBounds = true
        btnYoung.layer.borderWidth = 1
        btnYoung.layer.borderColor = UIColor.lightGray.cgColor
        
        btnAdult.layer.cornerRadius = 10
        btnAdult.clipsToBounds = true
        btnAdult.layer.borderWidth = 1
        btnAdult.layer.borderColor = UIColor.lightGray.cgColor
        
        btnSenior.layer.cornerRadius = 10
        btnSenior.clipsToBounds = true
        btnSenior.layer.borderWidth = 1
        btnSenior.layer.borderColor = UIColor.lightGray.cgColor
        
        btnSmallSize.layer.cornerRadius = 10
        btnSmallSize.clipsToBounds = true
        btnSmallSize.layer.borderWidth = 1
        btnSmallSize.layer.borderColor = UIColor.lightGray.cgColor
        
        btnMediumSize.layer.cornerRadius = 10
        btnMediumSize.clipsToBounds = true
        btnMediumSize.layer.borderWidth = 1
        btnMediumSize.layer.borderColor = UIColor.lightGray.cgColor
        
        btnLargeSize.layer.cornerRadius = 10
        btnLargeSize.clipsToBounds = true
        btnLargeSize.layer.borderWidth = 1
        btnLargeSize.layer.borderColor = UIColor.lightGray.cgColor
        
        btnXLSize.layer.cornerRadius = 10
        btnXLSize.clipsToBounds = true
        btnXLSize.layer.borderWidth = 1
        btnXLSize.layer.borderColor = UIColor.lightGray.cgColor
        
        btnGoodWithKids.layer.cornerRadius = 10
        btnGoodWithKids.clipsToBounds = true
        btnGoodWithKids.layer.borderWidth = 1
        btnGoodWithKids.layer.borderColor = UIColor.lightGray.cgColor
        
        btnGoodWithOtherDogs.layer.cornerRadius = 10
        btnGoodWithOtherDogs.clipsToBounds = true
        btnGoodWithOtherDogs.layer.borderWidth = 1
        btnGoodWithOtherDogs.layer.borderColor = UIColor.lightGray.cgColor
        
        btnGoodWithCats.layer.cornerRadius = 10
        btnGoodWithCats.clipsToBounds = true
        btnGoodWithCats.layer.borderWidth = 1
        btnGoodWithCats.layer.borderColor = UIColor.lightGray.cgColor
        
        btnhairLess.layer.cornerRadius = 10
        btnhairLess.clipsToBounds = true
        btnhairLess.layer.borderWidth = 1
        btnhairLess.layer.borderColor = UIColor.lightGray.cgColor
        
        btnShort.layer.cornerRadius = 10
        btnShort.clipsToBounds = true
        btnShort.layer.borderWidth = 1
        btnShort.layer.borderColor = UIColor.lightGray.cgColor
        
        btnMedium.layer.cornerRadius = 10
        btnMedium.clipsToBounds = true
        btnMedium.layer.borderWidth = 1
        btnMedium.layer.borderColor = UIColor.lightGray.cgColor
        
        btnLong.layer.cornerRadius = 10
        btnLong.clipsToBounds = true
        btnLong.layer.borderWidth = 1
        btnLong.layer.borderColor = UIColor.lightGray.cgColor
        
        btnWire.layer.cornerRadius = 10
        btnWire.clipsToBounds = true
        btnWire.layer.borderWidth = 1
        btnWire.layer.borderColor = UIColor.lightGray.cgColor
        
        btnCurly.layer.cornerRadius = 10
        btnCurly.clipsToBounds = true
        btnCurly.layer.borderWidth = 1
        btnCurly.layer.borderColor = UIColor.lightGray.cgColor
        
    }
  

    func configureUI(){
       // btnSortByNewest.backgroundColor = UIColor.init(rgb: 0x6e0b9c)
       // btnSortByNewest.setTitleColor(.white, for: .normal)
        tblBreed.rowHeight = 70
        sortBtnArray = [btnSortByNewest,btnSortByOldest,btnSortByNearest,btnSortByFuthest,btnSortByRandom]
        for btn in sortBtnArray {
            if FilterItems.shared.isAlreadySortedItemSelected(btn.titleLabel?.text ?? "") {
                btn.backgroundColor = UIColor.init(rgb: 0x6e0b9c)
                btn.setTitleColor(.white, for: .normal)
                btn.isSelected = true
            }
           
        }
        
        distanceBtnArray = [btnTenMiles,btnTwentyFiveMiles,btnFiftyMiles,btnHundredMiles,btnCustomMiles]
        
        for btn in distanceBtnArray {
            if FilterItems.shared.isAlreadyItemSelected(btn.titleLabel?.text ?? "") {
                btn.backgroundColor = UIColor.init(rgb: 0x6e0b9c)
                btn.setTitleColor(.white, for: .normal)
                btn.isSelected = true
            }
           
        }
        
        ageOptionBtnArray = [btnBaby,btnYoung,btnAdult,btnSenior]

        for btn in ageOptionBtnArray {
            if FilterItems.shared.isAlreadyItemSelected(btn.titleLabel?.text ?? "") {
                btn.backgroundColor = UIColor.init(rgb: 0x6e0b9c)
                btn.setTitleColor(.white, for: .normal)
                btn.isSelected = true
            }
           
        }
        
        sizeOptionBtnArray = [btnSmallSize,btnMediumSize,btnLargeSize,btnXLSize]

        for btn in sizeOptionBtnArray {
            if FilterItems.shared.isAlreadyItemSelected(btn.titleLabel?.text ?? "") {
                btn.backgroundColor = UIColor.init(rgb: 0x6e0b9c)
                btn.setTitleColor(.white, for: .normal)
                btn.isSelected = true
            }
           
        }
        
        goodWithOptionBtnArray = [btnGoodWithKids,btnGoodWithOtherDogs,btnGoodWithCats]

        for btn in goodWithOptionBtnArray {
            if FilterItems.shared.isAlreadyItemSelected(btn.titleLabel?.text ?? "") {
                btn.backgroundColor = UIColor.init(rgb: 0x6e0b9c)
                btn.setTitleColor(.white, for: .normal)
                btn.isSelected = true
            }
           
        }
        
        coatOptionBtnArray = [btnhairLess,btnShort,btnMedium,btnLong,btnWire,btnCurly]

        for btn in coatOptionBtnArray {
            if FilterItems.shared.isAlreadyItemSelected(btn.titleLabel?.text ?? "") {
                btn.backgroundColor = UIColor.init(rgb: 0x6e0b9c)
                btn.setTitleColor(.white, for: .normal)
                btn.isSelected = true
            }
           
        }
        
        allOptionBtnArray = [btnSortByNewest,btnSortByOldest,btnSortByNearest,btnSortByFuthest,btnSortByRandom,btnTenMiles,btnTwentyFiveMiles,btnFiftyMiles,btnHundredMiles,btnCustomMiles,btnBaby,btnYoung,btnAdult,btnSenior,btnSmallSize,btnMediumSize,btnLargeSize,btnXLSize,btnGoodWithKids,btnGoodWithOtherDogs,btnGoodWithCats,btnhairLess,btnShort,btnMedium,btnLong,btnWire,btnCurly]

    }
    
   
    //MARK:- Action Methods
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.delegate?.didSelectItem(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetAction(_ sender: UIButton) {        
        for btn in allOptionBtnArray {
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(.black, for: .normal)
        }
        
        self.tblBreed.reloadData()
        self.tblShelter.reloadData()
        self.tblColor.reloadData()
        FilterItems.shared.removeAllItem()
        
    }

    @IBAction func sortByAction(_ sender: UIButton) {
        for btn in sortBtnArray  {
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


    }
    
    @IBAction func distanceAction(_ sender: UIButton) {
        for btn in distanceBtnArray  {
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(.black, for: .normal)
            if btn.isSelected {
                FilterItems.shared.removeItem(btn.titleLabel?.text ?? "")
            }
            btn.isSelected = false
        }
        FilterItems.shared.addItem(sender.titleLabel?.text ?? "")
        sender.isSelected = true
        sender.backgroundColor = UIColor.init(rgb: 0x6e0b9c)
        sender.setTitleColor(.white, for: .normal)

    }
    
    @objc func checkAction(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func ageButtonAction(_ sender: UIButton) {
        for btn in ageOptionBtnArray {
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(.black, for: .normal)
            if btn.isSelected {
                FilterItems.shared.removeItem(btn.titleLabel?.text ?? "")
            }
            btn.isSelected = false
        }
        FilterItems.shared.addItem(sender.titleLabel?.text ?? "")
        sender.isSelected = true
        sender.backgroundColor = UIColor.init(rgb: 0x6e0b9c)
        sender.setTitleColor(.white, for: .normal)

    }
    
    @IBAction func sizeButtonAction(_ sender: UIButton) {
        for btn in sizeOptionBtnArray  {
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(.black, for: .normal)
            if btn.isSelected {
                FilterItems.shared.removeItem(btn.titleLabel?.text ?? "")
            }
            btn.isSelected = false
        }
        FilterItems.shared.addItem(sender.titleLabel?.text ?? "")
        sender.isSelected = true
        sender.backgroundColor = UIColor.init(rgb: 0x6e0b9c)
        sender.setTitleColor(.white, for: .normal)
    }
    
    @IBAction func goodWithButtonAction(_ sender: UIButton) {
        for btn in goodWithOptionBtnArray  {
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(.black, for: .normal)
            if btn.isSelected {
                FilterItems.shared.removeItem(btn.titleLabel?.text ?? "")
            }
            btn.isSelected = false
        }
        FilterItems.shared.addItem(sender.titleLabel?.text ?? "")
        sender.isSelected = true
        sender.backgroundColor = UIColor.init(rgb: 0x6e0b9c)
        sender.setTitleColor(.white, for: .normal)
    }
    
    @IBAction func coatLengthButtonAction(_ sender: UIButton) {
        for btn in coatOptionBtnArray  {
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(.black, for: .normal)
            if btn.isSelected {
                FilterItems.shared.removeItem(btn.titleLabel?.text ?? "")
            }
            btn.isSelected = false
        }
        FilterItems.shared.addItem(sender.titleLabel?.text ?? "")
        sender.isSelected = true
        sender.backgroundColor = UIColor.init(rgb: 0x6e0b9c)
        sender.setTitleColor(.white, for: .normal)


    }
    
}

//MARK:- UITableViewDelegate,UITableViewDataSource
extension FilterVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblBreed {
            return viewModel.breedList.count
        }else if tableView == tblShelter {
            return viewModel.shelterList.count
        }else if tableView == tblColor {
            return viewModel.colorList.count
        }else{
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblBreed {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BreedTableViewCell") as? BreedTableViewCell else { return UITableViewCell() }
            let petModel = viewModel.breedList[indexPath.row]
            cell.breedModel = petModel
            cell.btnCheck.addTarget(self, action: #selector(checkAction), for: .touchUpInside)

            return cell
            
        }else if tableView == tblShelter {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShelterTableViewCell") as? ShelterTableViewCell else { return UITableViewCell() }
            let shelterModel = viewModel.shelterList[indexPath.row]
            cell.shelterModel = shelterModel
            cell.btnCheck.tag = indexPath.row
            cell.btnCheck.addTarget(self, action: #selector(checkAction), for: .touchUpInside)

            return cell
            
        }else if tableView == tblColor {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ColorTableViewCell") as? ColorTableViewCell else { return UITableViewCell() }
            let colorModel = viewModel.colorList[indexPath.row]
            cell.colorModel = colorModel
            cell.btnCheck.tag = indexPath.row
            cell.btnCheck.addTarget(self, action: #selector(checkAction), for: .touchUpInside)

            return cell
        }else{
            return UITableViewCell()
        }

        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

}
