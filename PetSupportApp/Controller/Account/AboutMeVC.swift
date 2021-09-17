//
//  AboutMeVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/18/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD

class AboutMeVC: UIViewController {
    @IBOutlet weak var lblProgess: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var province: UITextField!
    @IBOutlet weak var addAttachmentOutlet: UIButton!
    @IBOutlet weak var ageCheckImage: UIImageView!
    @IBOutlet weak var conditionCheckImage: UIImageView!
    
    var total:Float = 6.0
    var totalOptionFillup:Float = 0.0
    var isAgeSelected = false
    var isTermsAndserviceSelected = false
    var isPictureSelected = false
    var imageId : UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        address.delegate = self
        city.delegate = self
        phoneNumber.delegate = self
        province.delegate = self
        
        
        self.title = "Scheduler Profile"
        progressView.progress = 0.0/total
        lblProgess.text = "0 % complete"
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
        address.layer.cornerRadius = 10
        address.clipsToBounds = true
        address.layer.borderWidth = 1
        address.layer.borderColor = UIColor.lightGray.cgColor
        address.setLeftPaddingPoints(10)
        
        city.layer.cornerRadius = 10
        city.clipsToBounds = true
        city.layer.borderWidth = 1
        city.layer.borderColor = UIColor.lightGray.cgColor
        city.setLeftPaddingPoints(10)
        
        province.layer.cornerRadius = 10
        province.clipsToBounds = true
        province.layer.borderWidth = 1
        province.layer.borderColor = UIColor.lightGray.cgColor
        province.setLeftPaddingPoints(10)
        
        phoneNumber.layer.cornerRadius = 10
        phoneNumber.clipsToBounds = true
        phoneNumber.layer.borderWidth = 1
        phoneNumber.layer.borderColor = UIColor.lightGray.cgColor
        phoneNumber.setLeftPaddingPoints(10)
    }
    
    @IBAction func conditionAction(_ sender: Any) {
        isTermsAndserviceSelected = !isTermsAndserviceSelected
        conditionCheckImage.image = isTermsAndserviceSelected ? UIImage(named: "check") :  UIImage(named: "uncheck")
        if isTermsAndserviceSelected == true {
            totalOptionFillup += 1
            progressView.progress = totalOptionFillup/total
            let per = (totalOptionFillup/total)*100
            let perString = String(format: "%.2f", per)
            lblProgess.text = "\(perString)% complete"
        }else {
            totalOptionFillup -= 1
            progressView.progress = totalOptionFillup/total
            let per = (totalOptionFillup/total)*100
            let perString = String(format: "%.2f", per)
            lblProgess.text = "\(perString)% complete"
        }
    }
    
    @IBAction func ageAction(_ sender: Any) {
        isAgeSelected = !isAgeSelected
        ageCheckImage.image = isAgeSelected ? UIImage(named: "check") :  UIImage(named: "uncheck")
        if isAgeSelected == true {
            totalOptionFillup += 1
            progressView.progress = totalOptionFillup/total
            let per = (totalOptionFillup/total)*100
            let perString = String(format: "%.2f", per)
            lblProgess.text = "\(perString)% complete"
        }else {
            totalOptionFillup -= 1
            progressView.progress = totalOptionFillup/total
            let per = (totalOptionFillup/total)*100
            let perString = String(format: "%.2f", per)
            lblProgess.text = "\(perString)% complete"
        }
    }
    
    @IBAction func addImage(_ sender: Any) {
        let AlertController = UIAlertController(title: "Pet Support", message: "Select an image", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Take from camera", style: .default) { (action) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        let gallery = UIAlertAction(title: "Choose from gallery", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        AlertController.addAction(camera)
        AlertController.addAction(gallery)
        AlertController.addAction(cancel)
        
        self.present(AlertController, animated: true, completion: nil)
    }
    @IBAction func saveAction(_ sender: Any) {
        if address.text == "" {
            simpleAlert("Enter your address")
            address.layer.borderColor = UIColor.red.cgColor
        }else if city.text == "" {
            simpleAlert("Enter your city")
            city.layer.borderColor = UIColor.red.cgColor
        }else if province.text == "" {
            simpleAlert("Enter your Province / State")
            province.layer.borderColor = UIColor.red.cgColor
        }else if phoneNumber.text == "" {
            simpleAlert("Enter your phone number")
            phoneNumber.layer.borderColor = UIColor.red.cgColor
        }else if !isValidPhone(phone: phoneNumber.text!){
            simpleAlert("Invalid phone number")
            phoneNumber.layer.borderColor = UIColor.red.cgColor
        }else if !isPictureSelected {
            simpleAlert("Upload the document picture")
        }else if !isAgeSelected {
            simpleAlert("Check mark the age")
        }else if !isTermsAndserviceSelected {
            simpleAlert("Accept the terms and condition")
        }else if imageId == nil {
            simpleAlert("Upload id image")
        }else if phoneNumber.text!.count < 10 {
            simpleAlert("Enter proper number with code")
        }
        else {
            address.layer.borderColor = UIColor.lightGray.cgColor
            city.layer.borderColor = UIColor.lightGray.cgColor
            province.layer.borderColor = UIColor.lightGray.cgColor
            phoneNumber.layer.borderColor = UIColor.lightGray.cgColor
            uploadArtistImage(image: self.imageId!)
            uploadOtherData()
        }
    }
    
}
extension AboutMeVC:UITextFieldDelegate {
    /*
     if !isPetOwnerTypeSelected {
         isPetOwnerTypeSelected = true
         totalOptionFillup += 1
         progressView.progress = totalOptionFillup/total
         let per = (totalOptionFillup/total)*100
         let perString = String(format: "%.2f", per)
         lblProgess.text = "\(perString)% complete"
     }
     */
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == address {
            if textField.text != "" {
                totalOptionFillup += 1
                progressView.progress = totalOptionFillup/total
                let per = (totalOptionFillup/total)*100
                let perString = String(format: "%.2f", per)
                lblProgess.text = "\(perString)% complete"
            }
        }else if textField == city {
            if textField.text != "" {
                totalOptionFillup += 1
                progressView.progress = totalOptionFillup/total
                let per = (totalOptionFillup/total)*100
                let perString = String(format: "%.2f", per)
                lblProgess.text = "\(perString)% complete"
            }
        }else if textField == province {
            if textField.text != "" {
                totalOptionFillup += 1
                progressView.progress = totalOptionFillup/total
                let per = (totalOptionFillup/total)*100
                let perString = String(format: "%.2f", per)
                lblProgess.text = "\(perString)% complete"
            }
        }else if textField == phoneNumber {
            if textField.text != "" {
                totalOptionFillup += 1
                progressView.progress = totalOptionFillup/total
                let per = (totalOptionFillup/total)*100
                let perString = String(format: "%.2f", per)
                lblProgess.text = "\(perString)% complete"
            }
        }
    }
}

extension AboutMeVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageId = image
            isPictureSelected = true
            totalOptionFillup += 1
            progressView.progress = totalOptionFillup/total
            let per = (totalOptionFillup/total)*100
            let perString = String(format: "%.2f", per)
            lblProgess.text = "\(perString)% complete"
            
            
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AboutMeVC {
    
    func uploadArtistImage(image:UIImage){
        
        KRProgressHUD.show()
//        let param: [String:Any] = ["schedulerProfile":["phoneNumber":intPhone!,"streetAddress":address.text!,"city":city.text!,"province":province.text!,"isOver18":true,"isConsented":true,"consents":["test"],"photoId":"testingImage"]]
        let param = ["":""]
        Alamofire.upload(multipartFormData:
            {
                (multipartFormData) in
                multipartFormData.append(image.jpegData(compressionQuality: 0.6)!, withName: "\(USER_ID)User_id_Image", fileName: "file.jpeg", mimeType: "image/jpeg")
                for (key, value) in param
                {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
        }, to:"https://petsupportapp.com/api/clients/schedulerProfile/update/\(USER_ID)",headers:nil)
        { (result) in
            switch result {
            case .success(let upload,_,_ ):
                upload.uploadProgress(closure: { (progress) in
                    print("Progress.. \(progress)")
                })
                upload.responseJSON
                    { response in
                        print(response.result)
                        if response.result.value != nil
                        {
                            let userData:JSON = JSON(response.result.value!)
                            print(JSON(response.result.value!)) // for JSOn format result
                            KRProgressHUD.dismiss()
                            self.simpleAlert("Profile updated")
                        }
                }
            case .failure( _):
                KRProgressHUD.dismiss()
                break
            }
        }
    }
    
    func uploadOtherData(){
        let intPhone = Int(phoneNumber.text!)
        let param: [String:Any] = ["schedulerProfile":["phoneNumber":intPhone!,"streetAddress":address.text!,"city":city.text!,"province":province.text!,"isOver18":true,"isConsented":true,"consents":["61342ec8c2bd0959a6e3b9ee"],"photoId":"testingImage"]]
        
        Alamofire.request("https://petsupportapp.com/api/clients/schedulerProfile/update/\(USER_ID)", method: .post, parameters: param).responseJSON { (response) in
            if response.result.isSuccess {
                print(response.result.value!)
            }
        }
    }
    
}
