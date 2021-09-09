//
//  EditAcountVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/18/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD
class EditAcountVC: UIViewController {
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtPostcode: UITextField!

    
    @IBOutlet weak var submitButton: UIButton!
    
    
    var isTermsAndserviceSelected = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Account"
        setupFields()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        txtFirstName.text = FIRST_NAME
        txtLastName.text = LAST_NAME
        txtPhone.text = EMAIL

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

    }
   
    
    override func viewDidLayoutSubviews() {
        makeRound()
    }
    
    func makeRound(){
        txtFirstName.layer.cornerRadius = 10
        txtFirstName.clipsToBounds = true
        txtFirstName.layer.borderWidth = 1
        txtFirstName.layer.borderColor = UIColor.lightGray.cgColor
        
        txtLastName.layer.cornerRadius = 10
        txtLastName.clipsToBounds = true
        txtLastName.layer.borderWidth = 1
        txtLastName.layer.borderColor = UIColor.lightGray.cgColor
        
        txtPhone.layer.cornerRadius = 10
        txtPhone.clipsToBounds = true
        txtPhone.layer.borderWidth = 1
        txtPhone.layer.borderColor = UIColor.lightGray.cgColor
        
        txtCountry.layer.cornerRadius = 10
        txtCountry.clipsToBounds = true
        txtCountry.layer.borderWidth = 1
        txtCountry.layer.borderColor = UIColor.lightGray.cgColor
        
        txtPostcode.layer.cornerRadius = 10
        txtPostcode.clipsToBounds = true
        txtPostcode.layer.borderWidth = 1
        txtPostcode.layer.borderColor = UIColor.lightGray.cgColor
        
        submitButton.layer.cornerRadius = submitButton.frame.height/2
        submitButton.clipsToBounds = true
        
    }
    
    fileprivate func setupFields() {
        txtFirstName.setLeftPaddingPoints(10)
        txtLastName.setLeftPaddingPoints(10)
        txtPostcode.setLeftPaddingPoints(10)
        txtCountry.setLeftPaddingPoints(10)
        txtPhone.setLeftPaddingPoints(10)
    }
    
   
    
    //MARK: - IBActions
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        if txtLastName.text == "" || txtFirstName.text == "" || txtPhone.text == "" {
            simpleAlert("Fill all fields")
        }else {
            updateClient(firstName: txtFirstName.text!, lastName: txtLastName.text!, email: txtPhone.text!)
        }
    }
    
    
}

//MARK:- UITextFieldDelegate
extension EditAcountVC : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
                
        return true
    }
}

extension  EditAcountVC{
    func updateClient(firstName:String,lastName:String,email:String){
        let params = ["firstname":firstName,"lastname":lastName,"email":email]
        Alamofire.request("https://petsupportapp.com/api/clients/update/\(USER_ID)", method: .post, parameters: params).responseJSON { (response) in
            if response.result.isSuccess {
                let data:JSON = JSON(response.result.value!)
                print(data)
                let alert = UIAlertController(title: "Pet Support", message: "Profile Updated", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.navigationController?.popToRootViewController(animated: true)
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
