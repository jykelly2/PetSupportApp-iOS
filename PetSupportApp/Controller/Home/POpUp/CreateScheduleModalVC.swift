//
//  CreateScheduleModalVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/13/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

class CreateScheduleModalVC: UIViewController {
    //MARK:- UIControl's Outlets
    
    @IBOutlet weak var lblHeader : UILabel!
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var btnClose : UIButton!
    @IBOutlet weak var btnSchedule: UIButton!

    @IBOutlet weak var txtMeetingDate: UITextField!
    @IBOutlet weak var txtFromDate: UITextField!
    @IBOutlet weak var txtToDate: UITextField!
    
    @IBOutlet private var meetingDateContainerVw: UIView!
    @IBOutlet private var fromdateContainerVw: UIView!
    @IBOutlet private var toDateContainerVw: UIView!
    @IBOutlet private var optionContainerVw: UIView!

    //MARK:- Class Variables
//    var pvDate          = UIDatePicker()
//    var pvFromTime          = UIDatePicker()
//    var pvToTime          = UIDatePicker()
//    var minDate : Date!
//    var dateFormatter = DateFormatter()
    let datePicker = UIDatePicker()
    var selectedTextField:UITextField =  UITextField()
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
       // initPickers()
    }
    override func viewDidLayoutSubviews() {
        makeRoundView()
    }
    
    //MARK:- Custome Methods

    func makeRoundView(){
        btnClose.layer.cornerRadius = btnClose.frame.height/2
        btnClose.clipsToBounds = true
        
        btnSchedule.layer.cornerRadius = btnSchedule.frame.height/2
        btnSchedule.clipsToBounds = true
        
        meetingDateContainerVw.layer.cornerRadius = 10
        meetingDateContainerVw.clipsToBounds = true
        meetingDateContainerVw.layer.borderWidth = 1
        meetingDateContainerVw.layer.borderColor = UIColor.lightGray.cgColor
        
        fromdateContainerVw.layer.cornerRadius = 10
        fromdateContainerVw.clipsToBounds = true
        fromdateContainerVw.layer.borderWidth = 1
        fromdateContainerVw.layer.borderColor = UIColor.lightGray.cgColor
        
        toDateContainerVw.layer.cornerRadius = 10
        toDateContainerVw.clipsToBounds = true
        toDateContainerVw.layer.borderWidth = 1
        toDateContainerVw.layer.borderColor = UIColor.lightGray.cgColor
    }
   
    
    
    func configureUI(){
        //self.mainView.alpha = 0.0

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
    
    func showDatePicker(_ txtField:UITextField) {
        selectedTextField = txtField
        if txtField == txtMeetingDate{
            datePicker.minimumDate = Date()
            datePicker.datePickerMode = .date
        }else if txtField == txtFromDate || txtField == txtToDate{
            datePicker.datePickerMode = UIDatePicker.Mode.time
            datePicker.minuteInterval = 30
        }
        datePicker.date = Date()
        datePicker.locale = .current

        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else {
            // Fallback on earlier versions
        }
        //ToolBar
           let toolbar = UIToolbar();
           toolbar.sizeToFit()
           //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
           toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        selectedTextField.inputAccessoryView = toolbar
        selectedTextField.inputView = datePicker
    }
    
    @objc func donedatePicker(){
      //For date formate
       let dateFormatter = DateFormatter()
        if selectedTextField == txtMeetingDate {
            dateFormatter.dateFormat = DateTimeFormaterEnum.ddmm_yyyy.rawValue
        }else if selectedTextField == txtFromDate || selectedTextField == txtToDate{
            dateFormatter.dateFormat = DateTimeFormaterEnum.hhmmA.rawValue         }
        selectedTextField.text = dateFormatter.string(from: datePicker.date)
       //dismiss date picker dialog
       self.view.endEditing(true)
    }

    @objc func cancelDatePicker(){
           //cancel button dismiss datepicker dialog
            self.view.endEditing(true)
    }
    /*
    func initPickers(){
        
        self.pvDate.minimumDate = Date()
        self.pvDate.datePickerMode = .date
        self.txtMeetingDate.inputView = self.pvDate
        self.pvDate.addTarget(self, action: #selector(handleDate(sender:)), for: .valueChanged)
        
        self.pvFromTime.timeZone = TimeZone.current
        self.pvFromTime.datePickerMode = .time
        self.pvFromTime.minuteInterval = 30
        self.pvFromTime.minimumDate = Date()
        self.txtFromDate.inputView = self.pvFromTime
        self.pvFromTime.addTarget(self, action: #selector(handleFromTime(sender:)), for: .valueChanged)
        
        self.pvToTime.timeZone = TimeZone.current
        self.pvToTime.datePickerMode = .time
        self.pvToTime.minuteInterval = 30
        self.txtToDate.inputView = self.pvToTime
        self.pvToTime.addTarget(self, action: #selector(handleToTime(sender:)), for: .valueChanged)
        
    }
    
    @objc func handleFromTime(sender: UIDatePicker){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateTimeFormaterEnum.hhmmA.rawValue         // "hh:mm a"
        
        self.txtFromDate.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func handleToTime(sender: UIDatePicker){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateTimeFormaterEnum.hhmmA.rawValue         // "hh:mm a"
        
        self.txtToDate.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func handleDate(sender: UIDatePicker){
        self.txtMeetingDate.text = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateTimeFormaterEnum.ddmm_yyyy.rawValue          // "dd/MM/yyyy"
        self.txtMeetingDate.text = dateFormatter.string(from: sender.date)
        self.minDate = sender.date
    }*/
    
    //MARK:- Action Methods
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.dismissAnimation()
    }
    
    @IBAction func scheduleButtonAction(_ sender: UIButton) {
        self.dismissAnimation()
        let vc = SSchedule.instantiateViewController(withIdentifier: "ConfirmScheduleVC") as! ConfirmScheduleVC
      // vc.petModel = petModel
       self.navigationController?.pushViewController(vc, animated: true)
    }

}

//MARK:- UITextFieldDelegate
extension CreateScheduleModalVC : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.showDatePicker(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       return true
    }
    
}

