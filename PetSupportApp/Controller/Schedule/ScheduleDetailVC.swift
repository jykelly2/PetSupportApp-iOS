//
//  ScheduleDetailVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/15/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

class ScheduleDetailVC: UIViewController {
    //MARK:- UIControl's Outlets
    @IBOutlet weak var lblMeetPet: UILabel!
    @IBOutlet weak var lblPetDescription: UILabel!
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var statusIconView: UIView!
    @IBOutlet weak var lblProgress: UILabel!
    @IBOutlet weak var lbldateTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStartTimeTitle: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblFees: UILabel!
    @IBOutlet weak var lblTotalTime: UILabel!
    @IBOutlet weak var lblTotalTimeTitle: UILabel!
    @IBOutlet weak var lblEndtime: UILabel!
    @IBOutlet weak var lblEndTimeTitle: UILabel!
    
    @IBOutlet weak var lblTotalFees: UILabel!
    @IBOutlet weak var lblcardLastfourDigit: UILabel!
    @IBOutlet weak var lblShelterName: UILabel!
    @IBOutlet weak var lblShelterAddress: UILabel!
    @IBOutlet weak var lblShelterPhone: UILabel!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    
    
    
    //MARK:- Class Variables
    var scheduleListModel:ScheduleListModel!

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
        switch scheduleListModel.petStatus {
        case .Approved:
            statusIconView.backgroundColor = .green
            break
        case .Reviewing:
            statusIconView.backgroundColor = .orange
        break

        case .InProgress:
            statusIconView.backgroundColor = .blue
        break
        }
        lblMeetPet.text =  scheduleListModel.petName
        lblProgress.text =  scheduleListModel.petStatus.rawValue

        
    }
    
    func makeCircle(){
        
        btnCancel.layer.cornerRadius = btnCancel.frame.height/2
        btnCancel.clipsToBounds = true
        btnCancel.layer.borderColor = UIColor.init(rgb: 0xE62BFF).cgColor
        btnCancel.layer.borderWidth = 1
        
        btnEdit.layer.cornerRadius = btnCancel.frame.height/2
        btnEdit.clipsToBounds = true
        
        statusIconView.layer.cornerRadius = statusIconView.frame.height/2
        statusIconView.clipsToBounds = true
        
    }
    
   
    //MARK:- Action Methods

    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
            
    @IBAction func scheduleOptionButtonAction(_ sender: UIButton) {
        
        let vc = SSchedule.instantiateViewController(withIdentifier: "ScheduleOptionVC") as! ScheduleOptionVC
        self.addChild(vc)
        vc.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
        
    }
    
    
    @IBAction func editButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
    }
    
}

