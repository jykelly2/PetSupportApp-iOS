//
//  SigninVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/18/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

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
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
       
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
       
    }
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        let vc = SAccount.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.present(vc, animated: true, completion: nil)
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
