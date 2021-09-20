//
//  AddCardVC.swift
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

class AddCardVC: UIViewController ,CLLocationManagerDelegate{

 
    @IBOutlet weak var countryPicker: CountryPickerView!
    @IBOutlet weak var postalCode: UITextField!
    
    var savedCards:SavedCards? = nil
    let locationManager = CLLocationManager()
    var cardType = ""
    var cardNumber = ""
    var expirationDate = ""
    var cvv = ""
    var country = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        countryPicker.delegate = self
        countryPicker.dataSource = self
        countryPicker.showPhoneCodeInView = false
        countryPicker.showCountryNameInView = true
        self.country = savedCards!.country
        self.postalCode.text = savedCards!.postoalCode
        self.cardType = savedCards!.cardType
        self.countryPicker.countryDetailsLabel.text = savedCards!.country
        var myCard : MFCardView
        myCard  = MFCardView(withViewController: self)
        myCard.delegate = self
        myCard.autoDismiss = true
        myCard.toast = true
        if let card = savedCards {
            let sepDate = card.expiryDate.components(separatedBy: "T")
            let formatter = DateFormatter()
               formatter.dateFormat = "yyyy-MM-dd"
               guard let date = formatter.date(from: sepDate[0]) else {
                   return
               }

               formatter.dateFormat = "yyyy"
               let year = formatter.string(from: date)
               formatter.dateFormat = "MM"
               let month = formatter.string(from: date)
               formatter.dateFormat = "dd"
               let day = formatter.string(from: date)
               print(year, month, day) // 2018 12 24
            let demoCard :Card? = Card(holderName: "", number: "\(card.cardNumber)", month: Month(rawValue:"\(month)")!, year: year, cvc: "\(card.cvv)", paymentType: Card.PaymentType.bank, cardType: .Visa, userId: 0)
        myCard.showCardWithCardDetails(card: demoCard!)
            
        }
        
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
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
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
    
}
extension AddCardVC : CountryPickerViewDelegate,CountryPickerViewDataSource {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        print(country.name)
        self.country = country.name
    }
    
    
}
extension AddCardVC : MFCardDelegate {
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
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}
extension AddCardVC {
    
    func saveCard(){
        KRProgressHUD.show()
        let intCardNumber = Int(cardNumber)
        let intCardCVC = Int(cvv)
        let params:[String:Any] = ["paymentCard":["cardType":cardType,"cardNumber":intCardNumber!,"expirationDate":expirationDate,"CVV":intCardCVC!,"country":country,"postalCode":postalCode.text!]]
        Alamofire.request("https://petsupportapp.com/api/clients/paymentCard/update/\(USER_ID)", method: .post, parameters: params).responseJSON { (response) in
            if response.result.isSuccess {
                print(response.result.value!)
                KRProgressHUD.dismiss()
                let alert = UIAlertController(title: "Pet Support", message: "Card Updated", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.navigationController?.popToRootViewController(animated: true)
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
   
}


