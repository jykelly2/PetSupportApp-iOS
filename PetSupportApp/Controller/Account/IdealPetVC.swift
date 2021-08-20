//
//  IdealPetVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/19/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

class IdealPetTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
       // imageIcon.layer.cornerRadius = imageIcon.frame.height/2
       // imageIcon.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class IdealPetVC: UIViewController {
    let viewModel = PetViewModel()

    @IBOutlet weak var tblIdealPet: UITableView!
    var arrayIdealPets = [Account]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My ideal pet"
        tblIdealPet.rowHeight = 50
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)

    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
//
//    }

}


extension IdealPetVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IdealPetTableViewCell", for: indexPath) as! IdealPetTableViewCell
        
        let idealPet = viewModel.idealPetList[indexPath.row]
        cell.itemName.text = idealPet.title
        cell.imageIcon.image = UIImage(named:idealPet.icon)
        
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SAccount.instantiateViewController(withIdentifier: "IdealPetDetailsVC") as! IdealPetDetailsVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.idealPetList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
