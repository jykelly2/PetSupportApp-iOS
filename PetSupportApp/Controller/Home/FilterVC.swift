//
//  SearchVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/9/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

class BreedTableViewCell: UITableViewCell {
    //MARK:- UIControl's Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblPetName: UILabel!
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var btnCheck: UIButton!

     var breedModel: BreedModel? {
        didSet{
            if var _breedModel = breedModel {
                lblPetName.text = _breedModel.petName
                petImageView.image = UIImage(named: "\(_breedModel.petImage)")
                if FilterItems.shared.isAlreadyItemSelected(_breedModel.petName) {
                    _breedModel.isSelected = true
                }else{
                    _breedModel.isSelected = false
                }
                btnCheck.isSelected = _breedModel.isSelected
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
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet private var distanceBtnContainerVw: UIView!

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
    
    //MARK:- Class Variables
    var sortBtnArray:[UIButton] = []
    var distanceBtnArray:[UIButton] = []

    let viewModel = PetViewModel()

    //MARK:- View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        shortBtnContainerVw.layer.cornerRadius = 10
        shortBtnContainerVw.clipsToBounds = true
        shortBtnContainerVw.layer.borderWidth = 1
        shortBtnContainerVw.layer.borderColor = UIColor.black.cgColor
        
        distanceBtnContainerVw.layer.cornerRadius = 10
        distanceBtnContainerVw.clipsToBounds = true
        distanceBtnContainerVw.layer.borderWidth = 1
        distanceBtnContainerVw.layer.borderColor = UIColor.black.cgColor
    }
    
    //MARK:- Custome Methods

    func configureUI(){
       // btnSortByNewest.backgroundColor = UIColor.init(rgb: 0x6e0b9c)
       // btnSortByNewest.setTitleColor(.white, for: .normal)
        searchTableView.rowHeight = 70
        sortBtnArray = [btnSortByNewest,btnSortByOldest,btnSortByNearest,btnSortByFuthest,btnSortByRandom]
        distanceBtnArray = [btnTenMiles,btnTwentyFiveMiles,btnFiftyMiles,btnHundredMiles,btnCustomMiles]
    }
    
   
    //MARK:- Action Methods
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetAction(_ sender: UIButton) {
        for btn in sortBtnArray {
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(.black, for: .normal)
        }
        for btn in distanceBtnArray {
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(.black, for: .normal)
        }
        self.searchTableView.reloadData()
        
    }

    @IBAction func sortByAction(_ sender: UIButton) {
        for btn in sortBtnArray {
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(.black, for: .normal)
        }
        
        sender.backgroundColor = UIColor.init(rgb: 0x6e0b9c)
        sender.setTitleColor(.white, for: .normal)

    }
    
    @IBAction func distanceAction(_ sender: UIButton) {
        for btn in distanceBtnArray {
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(.black, for: .normal)
        }
        
        sender.backgroundColor = UIColor.init(rgb: 0x6e0b9c)
        sender.setTitleColor(.white, for: .normal)

    }
    
    @objc func checkAction(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
    }
    
}

//MARK:- UITableViewDelegate,UITableViewDataSource
extension FilterVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.breedList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BreedTableViewCell") as? BreedTableViewCell else { return UITableViewCell() }
        let petModel = viewModel.breedList[indexPath.row]
        cell.breedModel = petModel
        cell.btnCheck.addTarget(self, action: #selector(checkAction), for: .touchUpInside)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

}
