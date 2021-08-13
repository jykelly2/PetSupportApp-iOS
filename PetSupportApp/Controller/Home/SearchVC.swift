//
//  SearchVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/10/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

class SearchHeaderCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblHeaderName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class SearchTableViewCell: UITableViewCell {
    //@IBOutlet weak var containerView: UIView!
    @IBOutlet var iconImageView : UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

    }
    
    override func layoutSubviews() {
        iconImageView.layer.cornerRadius = iconImageView.frame.height/2
        iconImageView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

class SearchVC: UIViewController {
    //MARK:- UIControl's Outlets
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblSearch: UITableView!

    //MARK:- Class Variables
    let viewModel = PetViewModel()
    var masterSearchlists:[SearchModel] = []
    var filteredSerachLists:[SearchModel] = []
    //MARK:- View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureUI()
        
    }
    override func viewDidLayoutSubviews() {
        searchView.layer.cornerRadius = searchView.frame.height/2
        searchView.clipsToBounds = true
    }

    //MARK:- Custome Methods

    func configureUI(){
        masterSearchlists = viewModel.searchList
        filteredSerachLists = viewModel.searchList
       
    }
    
    //MARK:- Action Methods

    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}

//MARK:- UITextFieldDelegate
extension SearchVC:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard textField.text != nil else {
            return true
        }
       // btnClearText.isHidden = false
        if(range.location == 0 && string == " "){
            return false
        }
        

            if range.location == 0 {
              //  btnClearText.isHidden = true

                self.filteredSerachLists = []
                self.filteredSerachLists = self.masterSearchlists
                self.tblSearch.reloadData()
                
            } else {
                var fulltext = textField.text! as String
                
                if string.isEmpty {
                    fulltext = String(fulltext.prefix(upTo: fulltext.index(before: fulltext.endIndex)))
                }
                else{
                    fulltext = fulltext + string
                }
               
               // self.filteredSerachLists = self.masterSearchlists.filter({$0.searchItems.localizedCaseInsensitiveContains("\(fulltext)")})
                self.tblSearch.reloadData()

            }
        return true
    }

}

//MARK:- UITableViewDelegate,UITableViewDataSource
extension SearchVC:UITableViewDelegate,UITableViewDataSource{

public func numberOfSections(in tableView: UITableView) -> Int {
    return filteredSerachLists.count
}


public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let sectionCell = tableView.dequeueReusableCell(withIdentifier: "SearchHeaderCell") as! SearchHeaderCell
    sectionCell.lblHeaderName.text = viewModel.searchList[section].headerName
    return sectionCell

}


func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.searchList[section].searchItems.count
}
func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
    
}
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
    cell.lblName.text = filteredSerachLists[indexPath.section].searchItems[indexPath.row]
    if viewModel.searchList[indexPath.section].isRecent {
        cell.iconImageView.image = UIImage(named: "recent")
    }else{
        cell.iconImageView.image = UIImage(named: "search")
    }

    return cell
}
    
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

