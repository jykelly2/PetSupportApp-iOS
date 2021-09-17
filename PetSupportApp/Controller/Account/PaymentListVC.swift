//
//  PaymentListVC.swift
//  PetSupportApp
//
//  Created by Anish on 9/16/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

class PaymentListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func cards(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "CardsListningVC")as! CardsListningVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func paypal(_ sender: Any) {
    }
    
}
