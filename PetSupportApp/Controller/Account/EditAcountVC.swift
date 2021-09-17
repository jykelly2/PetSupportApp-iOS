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
  

    
    @IBOutlet weak var submitButton: UIButton!
    
    
    var isTermsAndserviceSelected = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Account"
       
    
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
        txtFirstName.setLeftPaddingPoints(10)
        txtLastName.layer.cornerRadius = 10
        txtLastName.clipsToBounds = true
        txtLastName.layer.borderWidth = 1
        txtLastName.layer.borderColor = UIColor.lightGray.cgColor
        txtLastName.setLeftPaddingPoints(10)
        txtPhone.layer.cornerRadius = 10
        txtPhone.clipsToBounds = true
        txtPhone.layer.borderWidth = 1
        txtPhone.layer.borderColor = UIColor.lightGray.cgColor
        txtPhone.setLeftPaddingPoints(10)
        submitButton.layer.cornerRadius = submitButton.frame.height/2
        submitButton.clipsToBounds = true
        
    }
    

    
   
    
    //MARK: - IBActions
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        if txtLastName.text == "" || txtFirstName.text == "" || txtPhone.text == "" {
            simpleAlert("Fill all fields")
        }else if !isValidEmail(testStr: txtPhone.text!){
            simpleAlert("invalid email")
        }
        else {
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
                self.pixValues(json: data)
                let alert = UIAlertController(title: "Pet Support", message: "Profile Updated", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.navigationController?.popToRootViewController(animated: true)
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    func pixValues(json:JSON){
        
        let email = json["email"].string ?? ""
        let firstName = json["firstname"].string ?? ""
        let lastName = json["lastname"].string ?? ""
        
        self.txtFirstName.text = firstName
        self.txtPhone.text = email
        self.txtLastName.text = lastName
        
        FIRST_NAME = firstName
        LAST_NAME = lastName
        EMAIL = email
        UserDefaults.standard.setValue(firstName, forKey: "firstName")
        UserDefaults.standard.setValue(lastName, forKey: "lastName")
        UserDefaults.standard.setValue(email, forKey: "email")
    }
}
