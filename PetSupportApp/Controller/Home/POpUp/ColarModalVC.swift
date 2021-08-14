//
//  ColarModalVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/11/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

class ColorTableViewCell: UITableViewCell {
    //MARK:- UIControl's Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblColorName: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var btnCheck: UIButton!

     var colorModel: ColorModel? {
        didSet{
            if let _colorModel = colorModel {
                lblColorName.text = _colorModel.colorName
                colorView.backgroundColor = _colorModel.color
                btnCheck.setBackgroundImage(UIImage(named: "uncheck_box_icon"), for: .normal)
                btnCheck.setBackgroundImage(UIImage(named: "check_box_icon"), for: .selected)
                btnCheck.isSelected = _colorModel.isSelected
            }
        }
    }
    
    override func layoutSubviews() {
        colorView.layer.cornerRadius = colorView.frame.height/2
        colorView.clipsToBounds = true
    }
}

class ColarModalVC: UIViewController {
    //MARK:- UIControl's Outlets
    
    @IBOutlet weak var lblHeader : UILabel!
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var btnClose : UIButton!
    
    @IBOutlet weak var btnClearText: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblColor: UITableView!

    //MARK:- Class Variables
    let viewModel = PetViewModel()
    var masterColorlists:[ColorModel] = []
    var filteredColorLists:[ColorModel] = []

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
        masterColorlists = viewModel.colorList
        filteredColorLists = viewModel.colorList

        btnClearText.isHidden = true
        tblColor.rowHeight = 70
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
        self.dismissAnimation()
    }
    
    @IBAction func clearButtonAction(_ sender: UIButton) {
        btnClearText.isHidden = true
        txtSearch.text = nil
        self.filteredColorLists = []
        self.filteredColorLists = self.masterColorlists
        self.tblColor.reloadData()
    }
    
    @objc func checkAction(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
    }
  

}

//MARK:- UITableViewDelegate,UITableViewDataSource
extension ColarModalVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredColorLists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ColorTableViewCell") as? ColorTableViewCell else { return UITableViewCell() }
        let colorModel = filteredColorLists[indexPath.row]
        cell.colorModel = colorModel
        cell.btnCheck.addTarget(self, action: #selector(checkAction), for: .touchUpInside)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

}


//MARK:- UITextFieldDelegate
extension ColarModalVC : UITextFieldDelegate{
    
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

                self.filteredColorLists = []
                self.filteredColorLists = self.masterColorlists
                self.tblColor.reloadData()
                
            } else {
                var fulltext = textField.text! as String
                
                if string.isEmpty {
                    fulltext = String(fulltext.prefix(upTo: fulltext.index(before: fulltext.endIndex)))
                }
                else{
                    fulltext = fulltext + string
                }
               
                self.filteredColorLists = self.masterColorlists.filter({$0.colorName.localizedCaseInsensitiveContains("\(fulltext)")})
                self.tblColor.reloadData()

            }
        return true
    }
}
