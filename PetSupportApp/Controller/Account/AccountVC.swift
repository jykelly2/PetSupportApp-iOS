//
//  AccountVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/17/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var incompleBtnContainerV: UIView!
    @IBOutlet weak var btnIncompleteInfo: UIButton!
    @IBOutlet weak var btnDetails: UIButton!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class AccountVC: UIViewController, SignInModalVCDelegate {
    func didSelectSignOption(_ controller: SignInModalVC, signInOption: Int) {
        self.signIn()
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tblAccount: UITableView!
    var arrayAccountOptions = [Account]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tblAccount.rowHeight = 60
        updateArrayAccountOptions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    override func viewDidLayoutSubviews() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
    }
    
    func updateArrayAccountOptions(){
        arrayAccountOptions.append(Account(title: "Account Info", icon: "support-icon", identifier: "DashboardViewController"))
        arrayAccountOptions.append(Account(title: "Adopter Profile", icon: "logout-icon", identifier: "PriceBondListViewController"))
        arrayAccountOptions.append(Account(title: "Setting & Info", icon: "logout-icon", identifier: "DrawResultViewController"))
        arrayAccountOptions.append(Account(title: "Feedback", icon: "support-icon", identifier: "ContactUsViewController"))
        arrayAccountOptions.append(Account(title: "Sign in", icon: "logout-icon", identifier: "SupportViewController"))
        
        tblAccount.reloadData()
    }
    
    func signIn()  {
        let vc = SAccount.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.present(vc, animated: true, completion: nil)
    }

    func didSelectItem(_ index:Int){
        if index == 0 {
            let vc = SAccount.instantiateViewController(withIdentifier: "EditAcountVC") as! EditAcountVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if index == 1 {
            let vc = SAccount.instantiateViewController(withIdentifier: "AdopterProfileVC") as! AdopterProfileVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if index == 2 {
            let vc = SAccount.instantiateViewController(withIdentifier: "SettingInfoVC") as! SettingInfoVC
            self.navigationController?.pushViewController(vc, animated: true)            
        }else if index == 3 {
            
        }else if index == 4 {
            let vc = SAccount.instantiateViewController(withIdentifier: "SignInModalVC") as! SignInModalVC
            self.addChild(vc)
            vc.delegate = self
            vc.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(vc.view)
            vc.didMove(toParent: self)
        }
    }

}
extension AccountVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountTableViewCell", for: indexPath) as! AccountTableViewCell
        
        let account = arrayAccountOptions[indexPath.row]
        cell.itemName.text = account.title
        cell.imageIcon.image = UIImage(named:account.icon)
        let path = UIBezierPath(roundedRect: cell.incompleBtnContainerV.bounds, byRoundingCorners:[.topRight,.bottomLeft], cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = cell.incompleBtnContainerV.bounds;
        maskLayer.path = path.cgPath
        cell.incompleBtnContainerV.layer.mask = maskLayer;
        if indexPath.row == 0 {
            cell.incompleBtnContainerV.isHidden = false
        }else if indexPath.row == 1 {
            cell.incompleBtnContainerV.isHidden = false
        }else{
            cell.incompleBtnContainerV.isHidden = true
        }
        cell.btnIncompleteInfo.addTarget(self, action: #selector(pressedMenuItem(_:)), for: .touchUpInside)
        cell.btnIncompleteInfo.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectItem(indexPath.row)
    }
    
    @objc func pressedMenuItem(_ sender:UIButton) {
        debugPrint("pressedMenuItem:\(sender.tag)")
        if sender.tag == 0 {
            let vc = SAccount.instantiateViewController(withIdentifier: "EditAcountVC") as! EditAcountVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if sender.tag == 1 {
            let vc = SAccount.instantiateViewController(withIdentifier: "AdopterProfileVC") as! AdopterProfileVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayAccountOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
