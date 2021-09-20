//
//  CardsListningVC.swift
//  PetSupportApp
//
//  Created by Anish on 9/16/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit
import MFCard
import CountryPickerView
import CoreLocation
import Alamofire
import SwiftyJSON
import KRProgressHUD

class CardsListningVC: UIViewController,CLLocationManagerDelegate {

    
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var saveImage: UIImageView!
    @IBOutlet weak var saveCardOL: UIButton!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var addCardImage: UIImageView!
    @IBOutlet weak var addCardBtnOL: UIButton!
    @IBOutlet weak var countryPicker: CountryPickerView!
    @IBOutlet weak var postalCode: UITextField!
    @IBOutlet weak var popUpView: UIView!
    //layout
    //height constrainet for saved cards field to make the add new card on top
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var labelHeight: NSLayoutConstraint!
    
    let locationManager = CLLocationManager()
    var cardType = ""
    var cardNumber = ""
    var expirationDate = ""
    var cvv = ""
    var country = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if paymentCardSaved == false {
            saveImage.isHidden = true
            saveCardOL.isHidden = true
            lineView.isHidden = true
            imageHeight.constant = 0
            labelHeight.constant = 0
        }else{
            saveImage.isHidden = false
            saveCardOL.isHidden = false
            lineView.isHidden = false
            imageHeight.constant = 30
            labelHeight.constant = 30
        }
        popUpView.isHidden = true
        countryPicker.delegate = self
        countryPicker.dataSource = self
        countryPicker.showPhoneCodeInView = false
        countryPicker.showCountryNameInView = true
        self.country = countryPicker.selectedCountry.name
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[locations.count - 1]
        
        if userLocation.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
                if (error != nil){
                    print("error in reverseGeocode")
                }
                if placemarks != nil {
                let placemark = placemarks! as [CLPlacemark]
                if placemark.count > 0 {
                    let placemark = placemarks![0]
                    print(placemark.locality!)
                    print(placemark.administrativeArea!)
                    print(placemark.country!)
                   
                    self.postalCode.text = "\(placemark.postalCode!)"
                    
                    }
                }
            }
        }
        
    }
    @IBAction func saveCard(_ sender: Any) {
        if cardType == "" || cardNumber == "" || cvv == "" || expirationDate == ""{
            simpleAlert("Enter card details")
        }else if country == "" {
            simpleAlert("selected your country")
        }else if postalCode.text!.count < 6 || postalCode.text!.count > 6 {
            simpleAlert("invalid postal code")
        }else {
            saveCard()
        }
    }
    @IBAction func savedCards(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "SavedCardsVC")as! SavedCardsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addNew(_ sender: Any) {
        var myCard : MFCardView
        myCard  = MFCardView(withViewController: self)
        myCard.delegate = self
        myCard.autoDismiss = true
        myCard.toast = true
        myCard.showCard()
        
        navTitle.text = "Add Card"
        saveImage.isHidden = true
        saveCardOL.isHidden = true
        lineView.isHidden = true
        addCardImage.isHidden = true
        addCardBtnOL.isHidden = true
        popUpView.isHidden = false
      
    }
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }


}

extension CardsListningVC : CountryPickerViewDelegate,CountryPickerViewDataSource {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        print(country.name)
        self.country = country.name
    }
    
    
}
extension CardsListningVC : MFCardDelegate {
    func cardDoneButtonClicked(_ card: Card?, error: String?) {
        if error == nil{
            print(card!)
            self.cvv = (card?.cvc)!
            self.cardNumber = (card?.number)!
            let exMonth = card?.month
            let exYear = card?.year
            self.expirationDate = "\(exMonth!)-\(exYear!)"
        }else{
            simpleAlert("Invalid card Details")
        }
    }
    
    func cardTypeDidIdentify(_ cardType: String) {
        self.cardType = cardType
    }
    
    func cardDidClose() {
        navTitle.text = "Cards"
        if paymentCardSaved == false {
            saveImage.isHidden = true
            saveCardOL.isHidden = true
            lineView.isHidden = true
            imageHeight.constant = 0
            labelHeight.constant = 0
        }else{
            saveImage.isHidden = false
            saveCardOL.isHidden = false
            lineView.isHidden = false
            imageHeight.constant = 30
            labelHeight.constant = 30
        }
        addCardImage.isHidden = false
        addCardBtnOL.isHidden = false
        popUpView.isHidden = true
    }
    
    
}
extension CardsListningVC {
    
    func saveCard(){
        KRProgressHUD.show()
        let intCardNumber = Int(cardNumber)
        let intCardCVC = Int(cvv)
        let params:[String:Any] = ["paymentCard":["cardType":cardType,"cardNumber":intCardNumber!,"expirationDate":expirationDate,"CVV":intCardCVC!,"country":country,"postalCode":postalCode.text!]]
        Alamofire.request("https://petsupportapp.com/api/clients/paymentCard/update/\(USER_ID)", method: .post, parameters: params).responseJSON { (response) in
            if response.result.isSuccess {
                print(response.result.value!)
                KRProgressHUD.dismiss()
                self.simpleAlert("Card saved")
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
   
}
