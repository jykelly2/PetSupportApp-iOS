//
//  ShelterRescueModalVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/11/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

@objc protocol ShelterRescueModalVCDelegate {
    @objc func didSelectItem(_ isSelect: Bool)
}
class ShelterTableViewCell: UITableViewCell {
    //MARK:- UIControl's Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblShelterName: UILabel!
    @IBOutlet weak var lblShelterDistance: UILabel!
    @IBOutlet weak var btnCheck: UIButton!

     var shelterModel: ShelterModel? {
        didSet{
            if var _shelterModel = shelterModel {
                lblShelterName.text = _shelterModel.shelterName
                lblShelterDistance.text = _shelterModel.shelterDistance
                
                if FilterItems.shared.isAlreadyItemSelected(_shelterModel.shelterName) {
                    _shelterModel.isSelected = true
                }else{
                    _shelterModel.isSelected = false
                }
                btnCheck.isSelected = _shelterModel.isSelected
                btnCheck.setBackgroundImage(UIImage(named: "uncheck_box_icon"), for: .normal)
                btnCheck.setBackgroundImage(UIImage(named: "check_box_icon"), for: .selected)

            }
        }
    }
    
    override func layoutSubviews() {
    }
}


class ShelterRescueModalVC: UIViewController {
    //MARK:- UIControl's Outlets
    
    @IBOutlet weak var lblHeader : UILabel!
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var btnClose : UIButton!
    
    @IBOutlet weak var btnClearText: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblShelter: UITableView!

    //MARK:- Class Variables
    weak var delegate: ShelterRescueModalVCDelegate?
    let viewModel = PetViewModel()
    var masterShelterlists:[ShelterModel] = []
    var filteredShelterLists:[ShelterModel] = []

    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        makeRoundView()

    }
    override func viewDidLayoutSubviews() {
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
        masterShelterlists = viewModel.shelterList
        filteredShelterLists = viewModel.shelterList

        btnClearText.isHidden = true
        tblShelter.rowHeight = 70
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
        self.filteredShelterLists = []
        self.filteredShelterLists = self.masterShelterlists
        self.tblShelter.reloadData()
    }
    
    @objc func checkAction(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            let shelter = filteredShelterLists[sender.tag]
            FilterItems.shared.addItem(shelter.shelterName)
        }else{
            let shelter = filteredShelterLists[sender.tag]
            FilterItems.shared.removeItem(shelter.shelterName)
        }
    }
  

}

//MARK:- UITableViewDelegate,UITableViewDataSource
extension ShelterRescueModalVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredShelterLists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShelterTableViewCell") as? ShelterTableViewCell else { return UITableViewCell() }
        let shelterModel = filteredShelterLists[indexPath.row]
        cell.shelterModel = shelterModel
        cell.btnCheck.tag = indexPath.row
        cell.btnCheck.addTarget(self, action: #selector(checkAction), for: .touchUpInside)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

}


//MARK:- UITextFieldDelegate
extension ShelterRescueModalVC : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchView.layer.borderColor = UIColor.purple.cgColor
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

                self.filteredShelterLists = []
                self.filteredShelterLists = self.masterShelterlists
                self.tblShelter.reloadData()
                
            } else {
                var fulltext = textField.text! as String
                
                if string.isEmpty {
                    fulltext = String(fulltext.prefix(upTo: fulltext.index(before: fulltext.endIndex)))
                }
                else{
                    fulltext = fulltext + string
                }
               
                self.filteredShelterLists = self.masterShelterlists.filter({$0.shelterName.localizedCaseInsensitiveContains("\(fulltext)")})
                self.tblShelter.reloadData()

            }
        return true
    }
}
