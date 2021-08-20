//
//  SettingInfoVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/18/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

import UIKit

enum SettingDetailType: Int {
    case location_service = 0, notification, terms_of_services, privacy_policy, do_not_sell, about_ads
}

let settings = [["settingName": "Location services", "settingImageName": "support-icon", "settingEnum": SettingDetailType.location_service.rawValue], ["settingName": "Notifications", "settingImageName": "support-icon", "settingEnum": SettingDetailType.notification.rawValue]]

let informations = [["settingName": "Terms of service", "settingImageName": "support-icon", "settingEnum":SettingDetailType.terms_of_services.rawValue],
    ["settingName": "Privacy policy", "settingImageName": "support-icon", "settingEnum": SettingDetailType.privacy_policy.rawValue],
    ["settingName": "Do not sell my personal information", "settingImageName": "support-icon", "settingEnum": SettingDetailType.do_not_sell.rawValue],
    ["settingName": "About our ads", "settingImageName": "support-icon", "settingEnum": SettingDetailType.about_ads.rawValue]

]

class SettingTableViewCell: UITableViewCell {
   
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var lblSettingName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}


class SettingInfoVC: UIViewController{
    @IBOutlet weak var tblSetting: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings & Info"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func logOutAction(){
        
    }
    
    
    @objc func deleteAccountAction(){
        
    }
    }

extension SettingInfoVC: UITableViewDelegate, UITableViewDataSource{
    
    //MARK: -TableviewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "SearchHeaderCell") as! SearchHeaderCell
        switch section {
        case 0:
            headerCell.lblHeaderName.text = "SETTINGS"
            
        case 1:
            headerCell.lblHeaderName.text = "INFORMATION"
            
        default:
            break
        }
 
        headerCell.contentView.layer.borderColor = UIColor(rgb: 0xd8d8d8).cgColor
 
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return settings.count
        case 1:
            return informations.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        
        var data: [String: Any]!
        
        switch indexPath.section {
        case 0:
            data = settings[indexPath.row]
        case 1:
            data = informations[indexPath.row]
        
        default:
            break
        }
        
        cell.imageIcon.image = UIImage(named: data["settingImageName"] as! String)
        cell.lblSettingName.text = data["settingName"] as? String
        
       
        return cell
    }
    
    //MARK: -TableviewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if (cell?.tag)! == SettingDetailType.location_service.rawValue{
           // self.changePasswordAction()
        }else if (cell?.tag)! == SettingDetailType.notification.rawValue{
           self.logOutAction()

        }else if (cell?.tag)! == SettingDetailType.terms_of_services.rawValue{
            self.deleteAccountAction()

        }else if (cell?.tag)! == SettingDetailType.privacy_policy.rawValue{
            self.deleteAccountAction()

        }else if (cell?.tag)! == SettingDetailType.do_not_sell.rawValue{
            self.deleteAccountAction()

        }else if (cell?.tag)! == SettingDetailType.about_ads.rawValue{
            self.deleteAccountAction()

        }else{
            print("out")

            return
        }
    }

}





