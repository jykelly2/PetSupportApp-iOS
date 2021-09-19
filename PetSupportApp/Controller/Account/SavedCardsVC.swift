//
//  SavedCardsVC.swift
//  PetSupportApp
//
//  Created by Anish on 9/16/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD
import MFCard

class SavedCardsVC: UIViewController ,MFCardDelegate{

    

    @IBOutlet weak var tableView: UITableView!
    var savedCards = [SavedCards]()
    var currentSavedCards = [SavedCards]()
    override func viewDidLoad() {
        super.viewDidLoad()

       getUserSavedCards()
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

extension SavedCardsVC : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentSavedCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SavedCardCell
        let num = currentSavedCards[indexPath.row].cardNumber
        let str = String(num)
        let last4 = str.suffix(4)
        cell.cardNumber.text = "...\(last4)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
        var myCard : MFCardView
        myCard  = MFCardView(withViewController: self)
        myCard.delegate = self
        myCard.autoDismiss = true
        myCard.toast = true
        let demoCard :Card? = Card(holderName: "Rahul Chandnani", number: "6552552665526625", month: Month.Dec, year: "2019", cvc: "234", paymentType: Card.PaymentType.bank, cardType: CardType.Discover, userId: 0)
        myCard.showCardWithCardDetails(card: demoCard!)
 */
        let vc = storyboard?.instantiateViewController(identifier: "AddCardVC") as! AddCardVC
        vc.savedCards = self.currentSavedCards[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func cardDoneButtonClicked(_ card: Card?, error: String?) {
            
    }
    
    func cardTypeDidIdentify(_ cardType: String) {
        
    }
    
    func cardDidClose() {
        
    }
    func getUserSavedCards(){
        KRProgressHUD.show()
        Alamofire.request("https://petsupportapp.com/api/clients/paymentCard/\(USER_ID)", method: .get).responseJSON { (response) in
            if response.result.isSuccess {
                let data:JSON = JSON(response.result.value!)
                print(data)
                self.parseCards(json: data["paymentCard"])
            }
        }
    }
    func parseCards(json:JSON){
        let cardType = json["cardType"].string ?? ""
        let cardNum = json["cardNumber"].int ?? 0
        let expiry = json["expirationDate"].string ?? ""
        let cvv = json["CVV"].int ?? 0
        let country = json["country"].string ?? ""
        let postalCode = json["postalCode"].string ?? ""
        
        let data = SavedCards(cardType: cardType, cardNumber: cardNum, expiryDate: expiry, cvv: cvv, country: country, postoalCode: postalCode)
        self.currentSavedCards.append(data)
        tableView.reloadData()
        KRProgressHUD.dismiss()
    }
}

struct SavedCards {
    var cardType : String
    var cardNumber : Int
    var expiryDate : String
    var cvv : Int
    var country : String
    var postoalCode : String
}

