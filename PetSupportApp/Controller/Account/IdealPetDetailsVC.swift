//
//  IdealPetDetailsVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/20/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD

class IdealPetDetailsVC: UIViewController {
    @IBOutlet weak var lblProgess: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
 
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

    var total:Float = 7.0
    var totalOptionFillup:Float = 0.0
    var petPrefModel:PetPrefrences? = nil
    var type = "Dog"
    var age = "No preference"
    var gender = "No preference"
    var size  = "No preference"
    var breeds = [String]()
    var activeness = "No preference"
    var training = ["No preference"]
    var specialNeeds  = false
    
    /*
     "animalType": "Dog",
            "age": "Young" ,
            "gender": "Male",
            "size": "Small (0-25 ibs)",
            "breeds" : ["Golden Retriever", "French Bulldog"],
            "activeness" : "Very Active",
            "training" : ["isPottyTrained", "isLeashTrained"],
            "specialNeeds": true
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My ideal pet"
        agePreferenceBtnArray = [btnAgeNoPreference,btnPuppy,btnYoung,btnAdult,btnSenior]
        genderPreferenceBtnArray = [btnGenderNoPreference,btnMale,btnFemale]
        sizePreferenceBtnArray = [btnNoSizePreference,btnSmallSize,btnMediumSize,btnLargeSize,btnXLSize]
        activePreferenceBtnArray = [btnNoActivePreference,btnLapPet,btnLaidBack,btnActive,btnVeryActive]
        lookingPreferenceBtnArray = [btnNoLookingPreference,btnAllergyFriendly,btnHouseTrained]
        specialNeedBtnArray = [btnSpecialNeedYes,btnSpecialNeedNo]
        
        
        txtBreedSearch.setRightIamge("search2")

        progressView.progress = 0.0
        lblProgess.text = "0 % complete"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))

        if let model = petPrefModel {
            //AGE WORK
            
                if model.age == "Puppy" {
                    age = btnPuppy.titleLabel!.text ?? ""
                    btnPuppy.backgroundColor = UIColor.init(rgb: 0x8256D6)
                    btnPuppy.setTitleColor(.white, for: .normal)

                    if !isAgePreferenceSelected {
                        isAgePreferenceSelected = true
                        totalOptionFillup += 1
                        progressView.progress = totalOptionFillup/total
                        let per = (totalOptionFillup/total)*100
                        let perString = String(format: "%.2f", per)
                        lblProgess.text = "\(perString)% complete"
                    }
                }else if model.age == "Adult" {
                    age = btnAdult.titleLabel!.text ?? ""
                    btnAdult.backgroundColor = UIColor.init(rgb: 0x8256D6)
                    btnAdult.setTitleColor(.white, for: .normal)

                    if !isAgePreferenceSelected {
                        isAgePreferenceSelected = true
                        totalOptionFillup += 1
                        progressView.progress = totalOptionFillup/total
                        let per = (totalOptionFillup/total)*100
                        let perString = String(format: "%.2f", per)
                        lblProgess.text = "\(perString)% complete"
                    }
                }else if model.age == "Senior" {
                    age = btnSenior.titleLabel!.text ?? ""
                    btnSenior.backgroundColor = UIColor.init(rgb: 0x8256D6)
                    btnSenior.setTitleColor(.white, for: .normal)

                    if !isAgePreferenceSelected {
                        isAgePreferenceSelected = true
                        totalOptionFillup += 1
                        progressView.progress = totalOptionFillup/total
                        let per = (totalOptionFillup/total)*100
                        let perString = String(format: "%.2f", per)
                        lblProgess.text = "\(perString)% complete"
                    }
                }else if model.age == "Young dog"{
                    age = btnYoung.titleLabel!.text ?? ""
                    btnYoung.backgroundColor = UIColor.init(rgb: 0x8256D6)
                    btnYoung.setTitleColor(.white, for: .normal)

                    if !isAgePreferenceSelected {
                        isAgePreferenceSelected = true
                        totalOptionFillup += 1
                        progressView.progress = totalOptionFillup/total
                        let per = (totalOptionFillup/total)*100
                        let perString = String(format: "%.2f", per)
                        lblProgess.text = "\(perString)% complete"
                    }
                }else if model.age == "No preference"{
                    age = btnAgeNoPreference.titleLabel!.text ?? ""
                    btnAgeNoPreference.backgroundColor = UIColor.init(rgb: 0x8256D6)
                    btnAgeNoPreference.setTitleColor(.white, for: .normal)

                    if !isAgePreferenceSelected {
                        isAgePreferenceSelected = true
                        totalOptionFillup += 1
                        progressView.progress = totalOptionFillup/total
                        let per = (totalOptionFillup/total)*100
                        let perString = String(format: "%.2f", per)
                        lblProgess.text = "\(perString)% complete"
                    }

                }
           
            
                if model.gender == "Male" {
                    gender = btnMale.titleLabel?.text ?? ""
                    btnMale.backgroundColor = UIColor.init(rgb: 0x8256D6)
                    btnMale.setTitleColor(.white, for: .normal)
                    
                    if !isGenderPreferenceSelected {
                        isGenderPreferenceSelected = true
                        totalOptionFillup += 1
                        progressView.progress = totalOptionFillup/total
                        let per = (totalOptionFillup/total)*100
                        let perString = String(format: "%.2f", per)
                        lblProgess.text = "\(perString)% complete"
                    }
                }else if model.gender == "Female" {
                    gender = btnFemale.titleLabel?.text ?? ""
                    btnFemale.backgroundColor = UIColor.init(rgb: 0x8256D6)
                    btnFemale.setTitleColor(.white, for: .normal)

                    if !isGenderPreferenceSelected {
                        isGenderPreferenceSelected = true
                        totalOptionFillup += 1
                        progressView.progress = totalOptionFillup/total
                        let per = (totalOptionFillup/total)*100
                        let perString = String(format: "%.2f", per)
                        lblProgess.text = "\(perString)% complete"
                    }
                }else if model.gender == "No preference"{
                    gender = btnGenderNoPreference.titleLabel!.text ?? ""
                    btnGenderNoPreference.backgroundColor = UIColor.init(rgb: 0x8256D6)
                    btnGenderNoPreference.setTitleColor(.white, for: .normal)

                    if !isGenderPreferenceSelected {
                        isGenderPreferenceSelected = true
                        totalOptionFillup += 1
                        progressView.progress = totalOptionFillup/total
                        let per = (totalOptionFillup/total)*100
                        let perString = String(format: "%.2f", per)
                        lblProgess.text = "\(perString)% complete"
                    }

                }

          
            
           
            
            
           
                if model.size == "Small(0-25 lbs)" {
                    size = btnSmallSize.titleLabel?.text ?? ""
                    btnSmallSize.backgroundColor = UIColor.init(rgb: 0x8256D6)
                    btnSmallSize.setTitleColor(.white, for: .normal)

                    if !isSizePreferenceSelected {
                        isSizePreferenceSelected = true
                        totalOptionFillup += 1
                        progressView.progress = totalOptionFillup/total
                        let per = (totalOptionFillup/total)*100
                        let perString = String(format: "%.2f", per)
                        lblProgess.text = "\(perString)% complete"
                    }
                }else if model.size == "Medium(26-50 lbs)" {
                    size = btnMediumSize.titleLabel?.text ?? ""
                    btnMediumSize.backgroundColor = UIColor.init(rgb: 0x8256D6)
                    btnMediumSize.setTitleColor(.white, for: .normal)

                    if !isSizePreferenceSelected {
                        isSizePreferenceSelected = true
                        totalOptionFillup += 1
                        progressView.progress = totalOptionFillup/total
                        let per = (totalOptionFillup/total)*100
                        let perString = String(format: "%.2f", per)
                        lblProgess.text = "\(perString)% complete"
                    }
                }else if model.size == "Large(51-70 lbs)" {
                    size = btnLargeSize.titleLabel?.text ?? ""
                    btnLargeSize.backgroundColor = UIColor.init(rgb: 0x8256D6)
                    btnLargeSize.setTitleColor(.white, for: .normal)

                    if !isSizePreferenceSelected {
                        isSizePreferenceSelected = true
                        totalOptionFillup += 1
                        progressView.progress = totalOptionFillup/total
                        let per = (totalOptionFillup/total)*100
                        let perString = String(format: "%.2f", per)
                        lblProgess.text = "\(perString)% complete"
                    }
                }else if model.size == "XL (70+ lbs)" {
                    size = btnXLSize.titleLabel?.text ?? ""
                    btnXLSize.backgroundColor = UIColor.init(rgb: 0x8256D6)
                    btnXLSize.setTitleColor(.white, for: .normal)

                    if !isSizePreferenceSelected {
                        isSizePreferenceSelected = true
                        totalOptionFillup += 1
                        progressView.progress = totalOptionFillup/total
                        let per = (totalOptionFillup/total)*100
                        let perString = String(format: "%.2f", per)
                        lblProgess.text = "\(perString)% complete"
                    }
                }else if model.size == "No preference"{
                    size = btnNoSizePreference.titleLabel!.text ?? ""
                    btnNoSizePreference.backgroundColor = UIColor.init(rgb: 0x8256D6)
                    btnNoSizePreference.setTitleColor(.white, for: .normal)

                    if !isSizePreferenceSelected {
                        isSizePreferenceSelected = true
                        totalOptionFillup += 1
                        progressView.progress = totalOptionFillup/total
                        let per = (totalOptionFillup/total)*100
                        let perString = String(format: "%.2f", per)
                        lblProgess.text = "\(perString)% complete"
                    }

                }
            
            
            
            
            if model.activeness == "Lap-pet" {
                activeness = btnLapPet.titleLabel?.text ?? ""
                btnLapPet.backgroundColor = UIColor.init(rgb: 0x8256D6)
                btnLapPet.setTitleColor(.white, for: .normal)

                if !isActivePreferenceSelected {
                    isActivePreferenceSelected = true
                    totalOptionFillup += 1
                    progressView.progress = totalOptionFillup/total
                    let per = (totalOptionFillup/total)*100
                    let perString = String(format: "%.2f", per)
                    lblProgess.text = "\(perString)% complete"
                }
            }else if model.activeness == "Laid back" {
                activeness = btnLaidBack.titleLabel?.text ?? ""
                btnLaidBack.backgroundColor = UIColor.init(rgb: 0x8256D6)
                btnLaidBack.setTitleColor(.white, for: .normal)

                if !isActivePreferenceSelected {
                    isActivePreferenceSelected = true
                    totalOptionFillup += 1
                    progressView.progress = totalOptionFillup/total
                    let per = (totalOptionFillup/total)*100
                    let perString = String(format: "%.2f", per)
                    lblProgess.text = "\(perString)% complete"
                }
            }else if model.activeness == "Active" {
                activeness = btnActive.titleLabel?.text ?? ""
                btnActive.backgroundColor = UIColor.init(rgb: 0x8256D6)
                btnActive.setTitleColor(.white, for: .normal)

                if !isActivePreferenceSelected {
                    isActivePreferenceSelected = true
                    totalOptionFillup += 1
                    progressView.progress = totalOptionFillup/total
                    let per = (totalOptionFillup/total)*100
                    let perString = String(format: "%.2f", per)
                    lblProgess.text = "\(perString)% complete"
                }
            }else if model.activeness == "Very active" {
                activeness = btnVeryActive.titleLabel?.text ?? ""
                btnVeryActive.backgroundColor = UIColor.init(rgb: 0x8256D6)
                btnVeryActive.setTitleColor(.white, for: .normal)

                if !isActivePreferenceSelected {
                    isActivePreferenceSelected = true
                    totalOptionFillup += 1
                    progressView.progress = totalOptionFillup/total
                    let per = (totalOptionFillup/total)*100
                    let perString = String(format: "%.2f", per)
                    lblProgess.text = "\(perString)% complete"
                }
            }else if model.activeness == "No preference"{
                activeness = btnNoActivePreference.titleLabel!.text ?? ""
                btnNoActivePreference.backgroundColor = UIColor.init(rgb: 0x8256D6)
                btnNoActivePreference.setTitleColor(.white, for: .normal)

                if !isActivePreferenceSelected {
                    isActivePreferenceSelected = true
                    totalOptionFillup += 1
                    progressView.progress = totalOptionFillup/total
                    let per = (totalOptionFillup/total)*100
                    let perString = String(format: "%.2f", per)
                    lblProgess.text = "\(perString)% complete"
                }

            }

            
            if model.specialNeeds == true {
                btnSpecialNeedYes.backgroundColor = UIColor.init(rgb: 0x8256D6)
                btnSpecialNeedYes.setTitleColor(.black, for: .normal)
                specialNeeds = true
                if !isSpecialNeedSelected {
                    isSpecialNeedSelected = true
                    totalOptionFillup += 1
                    progressView.progress = totalOptionFillup/total
                    let per = (totalOptionFillup/total)*100
                    let perString = String(format: "%.2f", per)
                    lblProgess.text = "\(perString)% complete"
                }
            }else if model.specialNeeds == false {
                btnSpecialNeedNo.backgroundColor = UIColor.init(rgb: 0x8256D6)
                btnSpecialNeedNo.setTitleColor(.black, for: .normal)
                specialNeeds = false
                if !isSpecialNeedSelected {
                    isSpecialNeedSelected = true
                    totalOptionFillup += 1
                    progressView.progress = totalOptionFillup/total
                    let per = (totalOptionFillup/total)*100
                    let perString = String(format: "%.2f", per)
                    lblProgess.text = "\(perString)% complete"
                }
            }
            
            for item in model.training {
                if item == "Potty Trained"{
                    btnAllergyFriendly.backgroundColor = UIColor.init(rgb: 0x8256D6)
                    btnAllergyFriendly.setTitleColor(.white, for: .normal)
                    training.append(btnAllergyFriendly.titleLabel?.text ?? "")
                    if !isLookingPreferenceSelected {
                        isLookingPreferenceSelected = true
                        totalOptionFillup += 1
                        progressView.progress = totalOptionFillup/total
                        let per = (totalOptionFillup/total)*100
                        let perString = String(format: "%.2f", per)
                        lblProgess.text = "\(perString)% complete"
                    }

                }else if item == "Leash Trained" {
                    btnHouseTrained.backgroundColor = UIColor.init(rgb: 0x8256D6)
                    btnHouseTrained.setTitleColor(.white, for: .normal)
                    training.append(btnHouseTrained.titleLabel?.text ?? "")
                    if !isLookingPreferenceSelected {
                        isLookingPreferenceSelected = true
                        totalOptionFillup += 1
                        progressView.progress = totalOptionFillup/total
                        let per = (totalOptionFillup/total)*100
                        let perString = String(format: "%.2f", per)
                        lblProgess.text = "\(perString)% complete"
                    }

                }else if item == "No preference"{
                    activeness = btnNoLookingPreference.titleLabel!.text ?? ""
                    btnNoLookingPreference.backgroundColor = UIColor.init(rgb: 0x8256D6)
                    btnNoLookingPreference.setTitleColor(.white, for: .normal)

                    if !isLookingPreferenceSelected {
                        isLookingPreferenceSelected = true
                        totalOptionFillup += 1
                        progressView.progress = totalOptionFillup/total
                        let per = (totalOptionFillup/total)*100
                        let perString = String(format: "%.2f", per)
                        lblProgess.text = "\(perString)% complete"
                    }

                }
                
            }
            
            for dog in model.breed {
                if dog == "No preference" {
                    btnSearchNoPreference.superview?.backgroundColor = UIColor.init(rgb: 0x8256D6)
                    btnSearchNoPreference.setTitleColor(.white, for: .normal)
                    if !isBreadSelected {
                        isBreadSelected = true
                        totalOptionFillup += 1
                        progressView.progress = totalOptionFillup/total
                        let per = (totalOptionFillup/total)*100
                        let perString = String(format: "%.2f", per)
                        lblProgess.text = "\(perString)% complete"
                  }
                }else {
                txtBreedSearch.text = dog
                txtBreedSearch.superview?.backgroundColor = UIColor.init(rgb: 0x8256D6)
                txtBreedSearch.textColor = .white
                if !isBreadSelected {
                    isBreadSelected = true
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
    
    
    override func viewDidLayoutSubviews() {
        makeRound()
    }
    
    
    func makeRound(){
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
    
    @objc func saveTapped(){
        print("this is total breed count = \(breeds.count)")
        if totalOptionFillup != 7 {
            if leashPottyNoPref == false {
                if training.contains("Potty Trained") || training.contains("Leash Trained") {
                    training.removeAll { $0 == "No preference" }
                }
            }else {
                training.removeAll()
                training.append("No preference")
            }
           
            if breeds.count <= 0 {
                breeds.append("No preference")
            }
            updatePref(animalType: type, age: age, gender: gender, size: size, breed: breeds, activeness: activeness, training: training, specialNeeds: specialNeeds, isCompleted: false)
        }else{
            if leashPottyNoPref == false {
                if training.contains("Potty Trained") || training.contains("Leash Trained") {
                    training.removeAll { $0 == "No preference" }
                }
            }else {
                training.removeAll()
                training.append("No preference")
            }
            if breeds.count <= 0 {
                breeds.append("No preference")
            }
            updatePref(animalType: type, age: age, gender: gender, size: size, breed: breeds, activeness: activeness, training: training, specialNeeds: specialNeeds, isCompleted: true)
        }
    }
    var potty = false
    var leash = false
    var leashPottyNoPref = false
    @IBAction func lookingNoPrefrence(_ sender: UIButton) {
        leashPottyNoPref = true
        btnAllergyFriendly.isSelected = false
        btnHouseTrained.isSelected = false
        btnAllergyFriendly.setTitleColor(.black, for: .normal)
        btnAllergyFriendly.backgroundColor = UIColor.white
        btnHouseTrained.backgroundColor = UIColor.white
        btnHouseTrained.setTitleColor(.black, for: .normal)
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
    
    @IBAction func lookingPreferenceButtonAction(_ sender:UIButton){
//        for btn in lookingPreferenceBtnArray {
//            btn.backgroundColor = UIColor.white
//            btn.setTitleColor(.black, for: .normal)
//        }
        leashPottyNoPref = false
        btnNoLookingPreference.backgroundColor = UIColor.white
        btnNoLookingPreference.setTitleColor(.black, for: .normal)
        if !sender.isSelected {
            sender.isSelected = true
            sender.backgroundColor = UIColor.init(rgb: 0x8256D6)
            sender.setTitleColor(.white, for: .normal)
            if sender.tag == 8 {
                potty = true
                training.append(sender.titleLabel?.text ?? "")
            }else if sender.tag == 9 {
                leash = true
                training.append(sender.titleLabel?.text ?? "")
            }
            
         }
         else {
            sender.isSelected = false
            sender.backgroundColor = UIColor.white
            sender.setTitleColor(.black, for: .normal)
            if sender.tag == 8 {
                potty = false
                training.removeAll { $0 == sender.titleLabel!.text }
            }else if sender.tag == 9 {
                leash = false
                training.removeAll { $0 == sender.titleLabel!.text }
            }
         }
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
        if sender.titleLabel?.text == "Yes"{
            specialNeeds = true
        }else {
            specialNeeds = false
        }
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
        if sender.titleLabel!.text == "Yes" {
            specialNeeds = true
        }else if sender.titleLabel!.text == "No"{
            specialNeeds = false
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
        age = sender.titleLabel!.text ?? ""
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
        gender = sender.titleLabel?.text ?? ""
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
        size = sender.titleLabel?.text ?? ""
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
        activeness = sender.titleLabel?.text ?? ""
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
                breeds.append(item)
                if !isBreadSelected {
                    isBreadSelected = true
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
         if textField == txtBreedSearch {
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
        }
        return true
    }
}

extension IdealPetDetailsVC {
    func updatePref(animalType:String,age:String,gender:String,size:String,breed:[String],activeness:String,training:[String],specialNeeds:Bool,isCompleted:Bool){
        let params:[String:Any] = ["petPreference":["animalType":animalType,"age":age,"gender":gender,"size":size,"breeds":breed,"activeness":activeness,"training":training,"specialNeeds":specialNeeds],"isCompleted":isCompleted]
        
        Alamofire.request("https://petsupportapp.com/api/clients/petPreference/update/\(USER_ID)", method: .post, parameters: params).responseJSON { (response) in
            if response.result.isSuccess {
                let data:JSON = JSON(response.result.value!)
                print(data)
                let alert = UIAlertController(title: "Pet Support", message: "Preference Saved", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.navigationController?.popToRootViewController(animated: true)
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}


