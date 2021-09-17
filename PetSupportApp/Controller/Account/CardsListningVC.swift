//
//  CardsListningVC.swift
//  PetSupportApp
//
//  Created by Anish on 9/16/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

class CardsListningVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func savedCards(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "SavedCardsVC")as! SavedCardsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addNew(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "AddCardVC")as! AddCardVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
