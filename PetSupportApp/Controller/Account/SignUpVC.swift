//
//  SignUpVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/18/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD


class SignUpVC: UIViewController {
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtPostcode: UITextField!
    @IBOutlet weak var checkBoxImageView: UIImageView!

    
    @IBOutlet weak var submitButton: UIButton!
    
    
    var isTermsAndserviceSelected = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFields()
    
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
        
        txtPassword.layer.cornerRadius = 10
        txtPassword.clipsToBounds = true
        txtPassword.layer.borderWidth = 1
        txtPassword.layer.borderColor = UIColor.lightGray.cgColor
        
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
        txtPassword.setLeftPaddingPoints(10)
    }
    
   
    
    //MARK: - IBActions
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
       // self.dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func checkTermsAndservice(_ sender: UIButton) {
        isTermsAndserviceSelected = !isTermsAndserviceSelected
        checkBoxImageView.image = isTermsAndserviceSelected ? UIImage(named: "check") :  UIImage(named: "uncheck")
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        if txtFirstName.text == "" || txtLastName.text == "" || txtPassword.text == "" || txtPhone.text == "" {
            self.simpleAlert("Fill all fields")
        }else if (!self.isValidEmail(testStr: (self.txtPhone.text)!)) {
            self.simpleAlert("Email is not valid")
        }else if txtPassword.text!.count <= 7 {
            self.simpleAlert("The password must be at least 8 characters.")
        }else if isTermsAndserviceSelected == false {
            self.simpleAlert("Please accept the agreement")
        }
        else {
            self.signUp(firstName: txtFirstName.text!, lastName: txtLastName.text!, email: txtPhone.text!, password: txtPassword.text!)
        }
    }
    
    
}

//MARK:- UITextFieldDelegate
extension SignUpVC : UITextFieldDelegate{
    
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
extension  SignUpVC {
    func signUp(firstName:String,lastName:String,email:String,password:String) {
        KRProgressHUD.show()
        let params = ["firstname":firstName,"email":email,"password":password,"lastname":lastName]
        Alamofire.request("https://petsupportapp.com/api/clients/register", method: .post, parameters: params).responseJSON { (response) in
            if response.result.isSuccess {
                let result:JSON = JSON(response.result.value!)
                print(result)
                if result["message"].string != nil {
                    self.simpleAlert(result["message"].string!)
                    KRProgressHUD.dismiss()
                }else {
                    self.parseSignupValues(json: result)
                }
            }else {
                KRProgressHUD.dismiss()
                print(response.result.error!.localizedDescription)
            }
        }
    }
    func parseSignupValues(json:JSON){
    
        let firstname = json["firstname"].string ?? ""
        let lastname = json["lastname"].string ?? ""
        let userid = json["_id"].string ?? ""
        let email = json["email"].string ?? ""
        
        UserDefaults.standard.setValue(firstname, forKey: "firstName")
        UserDefaults.standard.setValue(lastname, forKey: "lastName")
        UserDefaults.standard.setValue(userid, forKey: "userId")
        UserDefaults.standard.setValue(email, forKey: "email")
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        KRProgressHUD.dismiss()
        NAME = "\(firstname) \(lastname)"
        USER_ID = userid
        LOGGED_IN = true
        EMAIL = email
        FIRST_NAME = firstname
        LAST_NAME = lastname
       
        let alert = UIAlertController(title: "Pet Support", message: "You have successfully signup", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

