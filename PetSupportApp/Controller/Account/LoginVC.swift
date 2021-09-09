//
//  SigninVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/18/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD

class LoginVC: UIViewController {
    
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var welcomeBackLabel: UILabel!
    @IBOutlet weak var phoneEmailLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFields()
    
    }
    
    override func viewDidLayoutSubviews() {
        makeRound()
    }
    
    func makeRound(){
        phoneField.layer.cornerRadius = 10
        phoneField.clipsToBounds = true
        phoneField.layer.borderWidth = 1
        phoneField.layer.borderColor = UIColor.lightGray.cgColor
        
        passwordField.layer.cornerRadius = 10
        passwordField.clipsToBounds = true
        passwordField.layer.borderWidth = 1
        passwordField.layer.borderColor = UIColor.lightGray.cgColor
        
        loginButton.layer.cornerRadius = loginButton.frame.height/2
        loginButton.clipsToBounds = true
        
        registerButton.layer.cornerRadius = registerButton.frame.height/2
        registerButton.clipsToBounds = true
        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor.init(rgb: 0x8256D6).cgColor
    }
    
    fileprivate func setupFields() {
        phoneField.setLeftPaddingPoints(10)
        passwordField.setLeftPaddingPoints(10)
    }
    
   
    
    //MARK: - IBActions
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        if phoneField.text == "" || passwordField.text == "" {
            self.simpleAlert("Enter your email and password")
        }else if (!self.isValidEmail(testStr: (self.phoneField.text)!)) {
            self.simpleAlert("Email is not valid")
        }else if passwordField.text!.count <= 7 {
            self.simpleAlert("The password must be at least 8 characters.")
        }else {
            self.signIn(email: phoneField.text!, password: passwordField.text!)
        }
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
       
    }
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        let vc = SAccount.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
       // self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: - Service Methods
    
    func loginAction() {
        
    }
    
    
}

//MARK:- UITextFieldDelegate
extension LoginVC : UITextFieldDelegate{
    
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



extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setRightIamge(_ imageName:String) {
        self.rightViewMode = .always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: imageName)
        imageView.image = image
        self.rightView = imageView
    }
    
    func setLeftIamge(_ imageName:String) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: imageName)
        imageView.image = image
        self.leftView = imageView
        self.leftViewMode = .always
    }
    
 
}

extension LoginVC {
    func signIn(email:String,password:String) {
        KRProgressHUD.show()
        let params = ["email":email,"password":password]
        Alamofire.request("https://petsupportapp.com/api/clients/manual/login", method: .get, parameters: params).responseJSON { (response) in
            if response.result.isSuccess {
                let result:JSON = JSON(response.result.value!)
                print(result)
                if result["message"].string != nil {
                    self.simpleAlert(result["message"].string!)
                    KRProgressHUD.dismiss()
                }else {
                    self.parseSigninValues(json: result)
                }
            }else {
                KRProgressHUD.dismiss()
                print(response.result.error!.localizedDescription)
            }
        }
    }
    func parseSigninValues(json:JSON){
        let firstname = json["firstname"].string ?? ""
        let lastname = json["lastname"].string ?? ""
        let userid = json["_id"].string ?? ""
        let email = json["email"].string ?? ""
        
        UserDefaults.standard.setValue(firstname, forKey: "firstName")
        UserDefaults.standard.setValue(lastname, forKey: "lastName")
        UserDefaults.standard.setValue(userid, forKey: "userId")
        UserDefaults.standard.setValue(email, forKey: "email")
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        NAME = "\(firstname) \(lastname)"
        USER_ID = userid
        LOGGED_IN = true
        EMAIL = email
        FIRST_NAME = firstname
        LAST_NAME = lastname
        KRProgressHUD.dismiss()
        
       
    }
}
