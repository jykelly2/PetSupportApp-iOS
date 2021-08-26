//
//  IdealPetDetailsVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/20/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

class IdealPetDetailsVC: UIViewController {
    @IBOutlet weak var lblProgess: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var petrestrictionBreedSV: UIStackView!
    @IBOutlet weak var petRestrictionSizeSV: UIStackView!
    @IBOutlet weak var petSpecialNeedSV: UIStackView!
    @IBOutlet weak var petSearchSV: UIStackView!
    @IBOutlet weak var petActivitySV: UIStackView!
    @IBOutlet weak var petSizeSV: UIStackView!
    @IBOutlet weak var petGenderSV: UIStackView!
    @IBOutlet weak var petAgeSV: UIStackView!
    
    @IBOutlet weak var petAgeHSV: UIStackView!
    @IBOutlet weak var petSizeHSV: UIStackView!
    @IBOutlet weak var petActivityHSV: UIStackView!
    
    @IBOutlet weak var btnAgeNoPreference: UIButton!
    @IBOutlet weak var btnPuppy: UIButton!
    @IBOutlet weak var btnYoung: UIButton!
    @IBOutlet weak var btnAdult: UIButton!
    @IBOutlet weak var btnSenior: UIButton!
    
    @IBOutlet weak var btnGenderNoPreference: UIButton!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    
    @IBOutlet weak var btnNoSizePreference: UIButton!
    @IBOutlet weak var btnSmallSize: UIButton!
    @IBOutlet weak var btnMediumSize: UIButton!
    @IBOutlet weak var btnLargeSize: UIButton!
    @IBOutlet weak var btnXLSize: UIButton!

    @IBOutlet weak var btnNoActivePreference: UIButton!
    @IBOutlet weak var btnLapPet: UIButton!
    @IBOutlet weak var btnLaidBack: UIButton!
    @IBOutlet weak var btnActive: UIButton!
    @IBOutlet weak var btnVeryActive: UIButton!
   
    @IBOutlet weak var btnSearchNoPreference: UIButton!
    @IBOutlet weak var txtBreedSearch: UITextField!
    
    @IBOutlet weak var btnNoLookingPreference: UIButton!
    @IBOutlet weak var btnAllergyFriendly: UIButton!
    @IBOutlet weak var btnHouseTrained: UIButton!
    
    @IBOutlet weak var btnSpecialNeedNo: UIButton!
    @IBOutlet weak var btnSpecialNeedYes: UIButton!
    
    @IBOutlet weak var btnNoRestriction: UIButton!
    @IBOutlet weak var btnOver25Restriction: UIButton!
    @IBOutlet weak var btnOver50Restriction: UIButton!
    @IBOutlet weak var btnOver70Restriction: UIButton!
   
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnNoBreedRestriction: UIButton!
    
    
    var isAgePreferenceSelected:Bool = false
    var isGenderPreferenceSelected:Bool = false
    var isSizePreferenceSelected:Bool = false
    var isActivePreferenceSelected:Bool = false
    var isLookingPreferenceSelected:Bool = false
    var isRestrictionPreferenceSelected:Bool = false
    var isSpecialNeedSelected:Bool = false
    var isNorestrictionSelected:Bool = false
    var isBreadSelected:Bool = false

    var agePreferenceBtnArray:[UIButton] = []
    var genderPreferenceBtnArray:[UIButton] = []
    var sizePreferenceBtnArray:[UIButton] = []
    var activePreferenceBtnArray:[UIButton] = []
    var lookingPreferenceBtnArray:[UIButton] = []
    var restrictionPreferenceBtnArray:[UIButton] = []
    var specialNeedBtnArray:[UIButton] = []
    var selectedTxtField: UITextField!

    var total:Float = 9.0
    var totalOptionFillup:Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My ideal pet"
        agePreferenceBtnArray = [btnAgeNoPreference,btnPuppy,btnYoung,btnAdult,btnSenior]
        genderPreferenceBtnArray = [btnGenderNoPreference,btnMale,btnFemale]
        sizePreferenceBtnArray = [btnNoSizePreference,btnSmallSize,btnMediumSize,btnLargeSize,btnXLSize]
        activePreferenceBtnArray = [btnNoActivePreference,btnLapPet,btnLaidBack,btnActive,btnVeryActive]
        lookingPreferenceBtnArray = [btnNoLookingPreference,btnAllergyFriendly,btnHouseTrained]
        restrictionPreferenceBtnArray = [btnNoRestriction,btnOver25Restriction,btnOver50Restriction,btnOver70Restriction]
        specialNeedBtnArray = [btnSpecialNeedYes,btnSpecialNeedNo]
        
        txtSearch.setRightIamge("search2")
        txtBreedSearch.setRightIamge("search2")

        progressView.progress = 0.0
        lblProgess.text = "0 % complete"

    }
    
    
    override func viewDidLayoutSubviews() {
        makeRound()
    }
    
    
    func makeRound(){
        petrestrictionBreedSV.layer.cornerRadius = 5
        petrestrictionBreedSV.clipsToBounds = true
        petrestrictionBreedSV.layer.borderWidth = 1
        petrestrictionBreedSV.layer.borderColor = UIColor.lightGray.cgColor
        
        petRestrictionSizeSV.layer.cornerRadius = 5
        petRestrictionSizeSV.clipsToBounds = true
        petRestrictionSizeSV.layer.borderWidth = 1
        petRestrictionSizeSV.layer.borderColor = UIColor.lightGray.cgColor
        
        petAgeHSV.layer.borderWidth = 1
        petAgeHSV.layer.borderColor = UIColor.lightGray.cgColor

        petSizeHSV.layer.borderWidth = 1
        petSizeHSV.layer.borderColor = UIColor.lightGray.cgColor
        
        petActivityHSV.layer.borderWidth = 1
        petActivityHSV.layer.borderColor = UIColor.lightGray.cgColor
        
        petSpecialNeedSV.layer.cornerRadius = 5
        petSpecialNeedSV.clipsToBounds = true
        petSpecialNeedSV.layer.borderWidth = 1
        petSpecialNeedSV.layer.borderColor = UIColor.lightGray.cgColor
        

        petSearchSV.layer.cornerRadius = 5
        petSearchSV.clipsToBounds = true
        petSearchSV.layer.borderWidth = 1
        petSearchSV.layer.borderColor = UIColor.lightGray.cgColor
        
        petActivitySV.layer.cornerRadius = 5
        petActivitySV.clipsToBounds = true
        petActivitySV.layer.borderWidth = 1
        petActivitySV.layer.borderColor = UIColor.lightGray.cgColor
        
        petSizeSV.layer.cornerRadius = 5
        petSizeSV.clipsToBounds = true
        petSizeSV.layer.borderWidth = 1
        petSizeSV.layer.borderColor = UIColor.lightGray.cgColor
        
        petGenderSV.layer.cornerRadius = 5
        petGenderSV.clipsToBounds = true
        petGenderSV.layer.borderWidth = 1
        petGenderSV.layer.borderColor = UIColor.lightGray.cgColor
        
        petAgeSV.layer.cornerRadius = 5
        petAgeSV.clipsToBounds = true
        petAgeSV.layer.borderWidth = 1
        petAgeSV.layer.borderColor = UIColor.lightGray.cgColor
        
        btnNoLookingPreference.layer.cornerRadius = 5
        btnNoLookingPreference.clipsToBounds = true
        btnNoLookingPreference.layer.borderWidth = 1
        btnNoLookingPreference.layer.borderColor = UIColor.lightGray.cgColor
        
        btnAllergyFriendly.layer.cornerRadius = 5
        btnAllergyFriendly.clipsToBounds = true
        btnAllergyFriendly.layer.borderWidth = 1
        btnAllergyFriendly.layer.borderColor = UIColor.lightGray.cgColor
        
        btnHouseTrained.layer.cornerRadius = 5
        btnHouseTrained.clipsToBounds = true
        btnHouseTrained.layer.borderWidth = 1
        btnHouseTrained.layer.borderColor = UIColor.lightGray.cgColor
    }
  
    @IBAction func lookingPreferenceButtonAction(_ sender:UIButton){
        for btn in lookingPreferenceBtnArray {
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(.black, for: .normal)
        }
        
        sender.backgroundColor = UIColor.init(rgb: 0x8256D6)
        sender.setTitleColor(.white, for: .normal)
        
        if !isLookingPreferenceSelected {
            isLookingPreferenceSelected = true
            totalOptionFillup += 1
            progressView.progress = totalOptionFillup/total
            let per = (totalOptionFillup/total)*100
            let perString = String(format: "%.2f", per)
            lblProgess.text = "\(perString)% complete"
        }

    }
    
    @IBAction func restrictionPreferenceButtonAction(_ sender:UIButton){
        for btn in restrictionPreferenceBtnArray {
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(.black, for: .normal)
        }
        
        sender.backgroundColor = UIColor.init(rgb: 0x8256D6)
        sender.setTitleColor(.white, for: .normal)
        
        if !isRestrictionPreferenceSelected {
            isRestrictionPreferenceSelected = true
            totalOptionFillup += 1
            progressView.progress = totalOptionFillup/total
            let per = (totalOptionFillup/total)*100
            let perString = String(format: "%.2f", per)
            lblProgess.text = "\(perString)% complete"
            
        }

    }
    
    @IBAction func specialNeedButtonAction(_ sender:UIButton){
        for btn in specialNeedBtnArray {
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(.black, for: .normal)
        }
        
        sender.backgroundColor = UIColor.init(rgb: 0x8256D6)
        sender.setTitleColor(.white, for: .normal)

        if !isSpecialNeedSelected {
            isSpecialNeedSelected = true
            totalOptionFillup += 1
            progressView.progress = totalOptionFillup/total
            let per = (totalOptionFillup/total)*100
            let perString = String(format: "%.2f", per)
            lblProgess.text = "\(perString)% complete"
        }
    }
    
    @IBAction func agePreferenceButtonAction(_ sender:UIButton){
        for btn in agePreferenceBtnArray {
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(.black, for: .normal)
        }
        
        sender.backgroundColor = UIColor.init(rgb: 0x8256D6)
        sender.setTitleColor(.white, for: .normal)

        if !isAgePreferenceSelected {
            isAgePreferenceSelected = true
            totalOptionFillup += 1
            progressView.progress = totalOptionFillup/total
            let per = (totalOptionFillup/total)*100
            let perString = String(format: "%.2f", per)
            lblProgess.text = "\(perString)% complete"
        }
    }
    
    @IBAction func genderPreferenceButtonAction(_ sender:UIButton){
        for btn in genderPreferenceBtnArray {
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(.black, for: .normal)
        }
        
        sender.backgroundColor = UIColor.init(rgb: 0x8256D6)
        sender.setTitleColor(.white, for: .normal)

        if !isGenderPreferenceSelected {
            isGenderPreferenceSelected = true
            totalOptionFillup += 1
            progressView.progress = totalOptionFillup/total
            let per = (totalOptionFillup/total)*100
            let perString = String(format: "%.2f", per)
            lblProgess.text = "\(perString)% complete"
        }
    }
    
    @IBAction func sizePreferenceButtonAction(_ sender:UIButton){
        for btn in sizePreferenceBtnArray {
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(.black, for: .normal)
        }
        
        sender.backgroundColor = UIColor.init(rgb: 0x8256D6)
        sender.setTitleColor(.white, for: .normal)

        if !isSizePreferenceSelected {
            isSizePreferenceSelected = true
            totalOptionFillup += 1
            progressView.progress = totalOptionFillup/total
            let per = (totalOptionFillup/total)*100
            let perString = String(format: "%.2f", per)
            lblProgess.text = "\(perString)% complete"
        }
    }
    
    @IBAction func activePreferenceButtonAction(_ sender:UIButton){
        for btn in activePreferenceBtnArray {
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(.black, for: .normal)
        }
        
        sender.backgroundColor = UIColor.init(rgb: 0x8256D6)
        sender.setTitleColor(.white, for: .normal)

        if !isActivePreferenceSelected {
            isActivePreferenceSelected = true
            totalOptionFillup += 1
            progressView.progress = totalOptionFillup/total
            let per = (totalOptionFillup/total)*100
            let perString = String(format: "%.2f", per)
            lblProgess.text = "\(perString)% complete"
        }
    }
    
    @IBAction func noRestrictionButtonAction(_ sender: UIButton) {
        txtSearch.superview?.backgroundColor = UIColor.white
        txtSearch.textColor = .black
        
        sender.backgroundColor = UIColor.init(rgb: 0x8256D6)
        sender.setTitleColor(.white, for: .normal)
        
        if !isNorestrictionSelected {
            isNorestrictionSelected = true
            totalOptionFillup += 1
            progressView.progress = totalOptionFillup/total
            let per = (totalOptionFillup/total)*100
            let perString = String(format: "%.2f", per)
            lblProgess.text = "\(perString)% complete"
        }
    }
    @IBAction func breedPreferenceSearchButtonAction(_ sender: UIButton) {
        txtBreedSearch.superview?.backgroundColor = UIColor.white
        txtBreedSearch.textColor = .black

        sender.backgroundColor = UIColor.init(rgb: 0x8256D6)
        sender.setTitleColor(.white, for: .normal)
        
        if !isBreadSelected {
            isBreadSelected = true
            totalOptionFillup += 1
            progressView.progress = totalOptionFillup/total
            let per = (totalOptionFillup/total)*100
            let perString = String(format: "%.2f", per)
            lblProgess.text = "\(perString)% complete"
        }
    }
    
    func goToBreadVC(){
        let destVC:BreadModalVC!  = SHome.instantiateViewController(withIdentifier: "BreadModalVC") as? BreadModalVC
        destVC.delegate = self
        destVC.isFromIdealpet = true
        self.addChild(destVC)
        destVC.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(destVC.view)
        destVC.didMove(toParent: self)
    }
}

extension IdealPetDetailsVC: BreadModalVCDelegate {
    func didSelectItem(_ isSelect: Bool) {
        
    }
    
    func didSelectBreadItem(_ item: String) {
        if item.count > 0 {
            selectedTxtField.text = item
            if self.selectedTxtField == txtBreedSearch {
                if !isBreadSelected {
                    isBreadSelected = true
                    totalOptionFillup += 1
                    progressView.progress = totalOptionFillup/total
                    let per = (totalOptionFillup/total)*100
                    let perString = String(format: "%.2f", per)
                    lblProgess.text = "\(perString)% complete"
                }
            }else if self.selectedTxtField == txtSearch{
                if !isNorestrictionSelected {
                    isNorestrictionSelected = true
                    totalOptionFillup += 1
                    progressView.progress = totalOptionFillup/total
                    let per = (totalOptionFillup/total)*100
                    let perString = String(format: "%.2f", per)
                    lblProgess.text = "\(perString)% complete"
                }
            }
        }
    }

    
}

//MARK:- UITextFieldDelegate
extension IdealPetDetailsVC : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        selectedTxtField = textField
        if textField == txtSearch {
            txtSearch.superview?.backgroundColor = UIColor.init(rgb: 0x8256D6)
            txtSearch.textColor = .white

            btnNoBreedRestriction.backgroundColor = .white
            btnNoBreedRestriction.setTitleColor(.lightGray, for: .normal)
        }else if textField == txtBreedSearch {
            txtBreedSearch.superview?.backgroundColor = UIColor.init(rgb: 0x8256D6)
            txtBreedSearch.textColor = .white
            
            btnSearchNoPreference.backgroundColor = .white
            btnSearchNoPreference.setTitleColor(.lightGray, for: .normal)
        }
        self.goToBreadVC()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.resignFirstResponder()
        if textField == txtBreedSearch {
        }else if textField == txtSearch{
           
        }
        return true
    }
}
