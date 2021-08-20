//
//  AboutMeVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/18/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

class AboutMeVC: UIViewController {
    @IBOutlet weak var yardSV: UIStackView!
    @IBOutlet weak var outdoorSV: UIStackView!
    @IBOutlet weak var kidsSV: UIStackView!
    @IBOutlet weak var adoptingSV: UIStackView!
    @IBOutlet weak var currentPetAtHomeSV: UIStackView!
    @IBOutlet weak var petOwnerTypeStackView: UIStackView!
    @IBOutlet weak var kidsHSV: UIStackView!
    @IBOutlet weak var catsDogsSV: UIStackView!
    
    @IBOutlet weak var btnFirst: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnCurrent: UIButton!
    @IBOutlet weak var btnNone: UIButton!
    @IBOutlet weak var btnCats: UIButton!
    @IBOutlet weak var btnDogs: UIButton!
    @IBOutlet weak var btnBoth: UIButton!
    @IBOutlet weak var btnMySelf: UIButton!
    @IBOutlet weak var btnFamily: UIButton!
    @IBOutlet weak var btnKidsNone: UIButton!
    @IBOutlet weak var btnUnder8: UIButton!
    @IBOutlet weak var btn8andMore: UIButton!
    @IBOutlet weak var btnOlder: UIButton!
    @IBOutlet weak var btnNoYard: UIButton!
    @IBOutlet weak var btnFenchedYard: UIButton!
    @IBOutlet weak var btnOpenYard: UIButton!
    @IBOutlet weak var btnOutDoorArea: UIButton!
    @IBOutlet weak var btnNearByPark: UIButton!
    
    
    var yardBtnArray:[UIButton] = []
    var kidsBtnArray:[UIButton] = []
    var adoptingBtnArray:[UIButton] = []
    var currentPetBtnArray:[UIButton] = []
    var petOwnerBtnTypeArray:[UIButton] = []
    var outDoorParkBtnTypeArray:[UIButton] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "About Me"
        
        petOwnerBtnTypeArray = [btnFirst,btnPrevious,btnCurrent]
        currentPetBtnArray = [btnNone,btnCats,btnDogs,btnBoth]
        adoptingBtnArray = [btnMySelf,btnFamily]
        kidsBtnArray = [btnKidsNone,btnUnder8,btn8andMore,btnOlder]
        yardBtnArray = [btnNoYard,btnFenchedYard,btnOpenYard]
        petOwnerBtnTypeArray = [btnFirst,btnPrevious,btnCurrent]
        outDoorParkBtnTypeArray = [btnOutDoorArea,btnNearByPark]
    }
    
    override func viewDidLayoutSubviews() {
        makeRound()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    
    func makeRound(){
        yardSV.layer.cornerRadius = 5
        yardSV.clipsToBounds = true
        yardSV.layer.borderWidth = 1
        yardSV.layer.borderColor = UIColor.lightGray.cgColor
        
        kidsSV.layer.cornerRadius = 5
        kidsSV.clipsToBounds = true
        kidsSV.layer.borderWidth = 1
        kidsSV.layer.borderColor = UIColor.lightGray.cgColor
        
        catsDogsSV.layer.borderWidth = 1
        catsDogsSV.layer.borderColor = UIColor.lightGray.cgColor
        
        kidsHSV.layer.borderWidth = 1
        kidsHSV.layer.borderColor = UIColor.lightGray.cgColor
        
        adoptingSV.layer.cornerRadius = 5
        adoptingSV.clipsToBounds = true
        adoptingSV.layer.borderWidth = 1
        adoptingSV.layer.borderColor = UIColor.lightGray.cgColor
        
        currentPetAtHomeSV.layer.cornerRadius = 5
        currentPetAtHomeSV.clipsToBounds = true
        currentPetAtHomeSV.layer.borderWidth = 1
        currentPetAtHomeSV.layer.borderColor = UIColor.lightGray.cgColor

        petOwnerTypeStackView.layer.cornerRadius = 5
        petOwnerTypeStackView.clipsToBounds = true
        petOwnerTypeStackView.layer.borderWidth = 1
        petOwnerTypeStackView.layer.borderColor = UIColor.lightGray.cgColor
        
        btnOutDoorArea.layer.cornerRadius = 5
        btnOutDoorArea.clipsToBounds = true
        btnOutDoorArea.layer.borderWidth = 1
        btnOutDoorArea.layer.borderColor = UIColor.lightGray.cgColor
        
        btnNearByPark.layer.cornerRadius = 5
        btnNearByPark.clipsToBounds = true
        btnNearByPark.layer.borderWidth = 1
        btnNearByPark.layer.borderColor = UIColor.lightGray.cgColor        
    }
    
    @IBAction func petOwnerButtonAction(_ sender:UIButton){
        for btn in petOwnerBtnTypeArray {
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(.black, for: .normal)
        }
        
        sender.backgroundColor = UIColor.init(rgb: 0x8256D6)
        sender.setTitleColor(.white, for: .normal)

    }
    
    @IBAction func currentAtHomeButtonAction(_ sender:UIButton){
        for btn in currentPetBtnArray {
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(.black, for: .normal)
        }
        
        sender.backgroundColor = UIColor.init(rgb: 0x8256D6)
        sender.setTitleColor(.white, for: .normal)

    }
    
    @IBAction func adoptingButtonAction(_ sender:UIButton){
        for btn in adoptingBtnArray {
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(.black, for: .normal)
        }
        
        sender.backgroundColor = UIColor.init(rgb: 0x8256D6)
        sender.setTitleColor(.white, for: .normal)

    }
    
    @IBAction func kidsButtonAction(_ sender:UIButton){
        for btn in kidsBtnArray {
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(.black, for: .normal)
        }
        
        sender.backgroundColor = UIColor.init(rgb: 0x8256D6)
        sender.setTitleColor(.white, for: .normal)

    }
    
    @IBAction func yardButtonAction(_ sender:UIButton){
        for btn in yardBtnArray {
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(.black, for: .normal)
        }
        
        sender.backgroundColor = UIColor.init(rgb: 0x8256D6)
        sender.setTitleColor(.white, for: .normal)

    }
    
    @IBAction func outDoorParkButtonAction(_ sender:UIButton){
        for btn in outDoorParkBtnTypeArray {
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(.black, for: .normal)
        }
        
        sender.backgroundColor = UIColor.init(rgb: 0x8256D6)
        sender.setTitleColor(.white, for: .normal)

    }
   

}
