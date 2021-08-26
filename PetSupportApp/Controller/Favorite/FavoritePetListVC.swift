//
//  FavoriteListVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/13/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

class PetListTableViewCell: UITableViewCell {
    //MARK:- UIControl's Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var lblPetName: UILabel!
    @IBOutlet weak var lblPetDescription: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnOption: UIButton!

     var favPetModel: FavPetModel? {
        didSet{
            if let _favPetModel = favPetModel {
                lblPetName.text = _favPetModel.petName
                lblPetDescription.text = _favPetModel.petDescription
                lblTime.text = _favPetModel.time
                petImageView.image = UIImage(named: _favPetModel.petImage)
            }
        }
    }
    
    override func layoutSubviews() {
        petImageView.layer.cornerRadius = 10
        petImageView.clipsToBounds = true
    }
}

class NoItemTableViewCell: UITableViewCell {
    //MARK:- UIControl's Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btnSelect: UIButton!
    
    override func layoutSubviews() {
    }
}



class FavoritePetListVC: UIViewController, PetFavOptionPopUpVCDelegate {
    func didFavPetOptionClose(_ isSelect: Bool) {
        if let parent = self.parent?.parent as? FavoriteVC{
            parent.hidefadeView()
        }
    }
    
    //MARK:- UIControl's Outlets
    @IBOutlet weak var lblTotalPets: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tblFavoritePet: UITableView!

    //MARK:- Class Variables
    let viewModel = PetViewModel()
    var favPetlists:[FavPetModel] = []

    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    override func viewDidLayoutSubviews() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let parent = self.parent?.parent as? FavoriteVC{
            parent.selectIndex = 0
            parent.setViewSelection(index: 0)
        }
    }
    //MARK:- Custome Methods
    
    func configureUI(){
//        headerView.layer.borderWidth = 0.5
//        headerView.layer.borderColor = UIColor.black.cgColor

        tblFavoritePet.rowHeight = 250
        favPetlists = viewModel.favPetList
        lblTotalPets.text = "\(viewModel.favPetList.count) Pets"

    }

    
    //MARK:- Action Methods
    @objc func optionButtonAction(_ sender:UIButton){
        
        let vc = SFavorite.instantiateViewController(withIdentifier: "PetFavOptionPopUpVC") as! PetFavOptionPopUpVC
        self.addChild(vc)
        vc.favPetModel = favPetlists[sender.tag]
        vc.delegate = self
        vc.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
        
        if let parent = self.parent?.parent as? FavoriteVC{
            parent.showfadeView()
        }
        
    }
    
    @objc func selectButtonAction(_ sender:UIButton){
    }
  

}

//MARK:- UITableViewDelegate,UITableViewDataSource
extension FavoritePetListVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return favPetlists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PetListTableViewCell") as? PetListTableViewCell else { return UITableViewCell() }
        let favPetModel = favPetlists[indexPath.row]
        cell.favPetModel = favPetModel
        cell.btnOption.tag = indexPath.row
        cell.btnOption.addTarget(self, action: #selector(optionButtonAction(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let favPetModel = favPetlists[indexPath.row]
         let petModel = PetModel.init(petName: favPetModel.petName, petImages: [favPetModel.petImage], petCollectionType: "NEW")
         let vc = SHome.instantiateViewController(withIdentifier: "AnimalDetailVC") as! AnimalDetailVC
        vc.petModel = petModel
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
