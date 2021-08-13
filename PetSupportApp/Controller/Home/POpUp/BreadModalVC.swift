//
//  BreadModalVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/11/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

@objc protocol BreadModalVCDelegate {
    @objc func didSelectItem(_ isSelect: Bool)
}

class BreadModalVC: UIViewController {
    //MARK:- UIControl's Outlets
    
    @IBOutlet weak var lblHeader : UILabel!
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var btnClose : UIButton!
    
    @IBOutlet weak var btnClearText: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblBreeds: UITableView!

    //MARK:- Class Variables
    weak var delegate: BreadModalVCDelegate?

    let viewModel = PetViewModel()
    var masterPetlists:[BreedModel] = []
    var filteredPetLists:[BreedModel] = []

    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    override func viewDidLayoutSubviews() {
        makeRoundView()
    }
   
    func makeRoundView(){
        btnClose.layer.cornerRadius = btnClose.frame.height/2
        btnClose.clipsToBounds = true
        
        searchView.layer.cornerRadius = 10
        searchView.clipsToBounds = true
        searchView.layer.borderWidth = 1
        searchView.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    //MARK:- Custome Methods
    
    func configureUI(){
        masterPetlists = viewModel.breedList
        filteredPetLists = viewModel.breedList

        btnClearText.isHidden = true
        tblBreeds.rowHeight = 70
        //self.mainView.alpha = 0.0
        self.view.backgroundColor = .clear
        self.presentAnimation()
    }

    func presentAnimation(){
        
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    func dismissAnimation(){
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }) { (finished : Bool) in
            if (finished){
                self.view.removeFromSuperview()
            }
        }
    }
    
    //MARK:- Action Methods
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.delegate?.didSelectItem(true)
        self.dismissAnimation()
    }
    
    @IBAction func clearButtonAction(_ sender: UIButton) {
        btnClearText.isHidden = true
        txtSearch.text = nil
        self.filteredPetLists = []
        self.filteredPetLists = self.masterPetlists
        self.tblBreeds.reloadData()
    }
    
    @objc func checkAction(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            let breed = filteredPetLists[sender.tag]
            FilterItems.shared.addItem(breed.petName)
        }else{
            let breed = filteredPetLists[sender.tag]
            FilterItems.shared.removeItem(breed.petName)
        }
    }
  

}

//MARK:- UITableViewDelegate,UITableViewDataSource
extension BreadModalVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetLists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BreedTableViewCell") as? BreedTableViewCell else { return UITableViewCell() }
        let breedModel = filteredPetLists[indexPath.row]
        cell.breedModel = breedModel
        cell.btnCheck.tag = indexPath.row
        cell.btnCheck.addTarget(self, action: #selector(checkAction), for: .touchUpInside)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

}


//MARK:- UITextFieldDelegate
extension BreadModalVC : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
                
        guard textField.text != nil else {
            return true
        }
        btnClearText.isHidden = false
        if(range.location == 0 && string == " "){
            return false
        }
        

            if range.location == 0 {
                btnClearText.isHidden = true

                self.filteredPetLists = []
                self.filteredPetLists = self.masterPetlists
                self.tblBreeds.reloadData()
                
            } else {
                var fulltext = textField.text! as String
                
                if string.isEmpty {
                    fulltext = String(fulltext.prefix(upTo: fulltext.index(before: fulltext.endIndex)))
                }
                else{
                    fulltext = fulltext + string
                }
               
                self.filteredPetLists = self.masterPetlists.filter({$0.petName.localizedCaseInsensitiveContains("\(fulltext)")})
                self.tblBreeds.reloadData()

            }
        return true
    }
}
