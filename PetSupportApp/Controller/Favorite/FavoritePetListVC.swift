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



class FavoritePetListVC: UIViewController {
    //MARK:- UIControl's Outlets
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
       
    //MARK:- Custome Methods
    
    func configureUI(){
        favPetlists = viewModel.favPetList
    }

    
    //MARK:- Action Methods
    @objc func optionButtonAction(_ sender:UIButton){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PetFavOptionPopUpVC") as! PetFavOptionPopUpVC
        self.addChild(vc)
        vc.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
        
    }
    
    @objc func selectButtonAction(_ sender:UIButton){
    }
  

}

//MARK:- UITableViewDelegate,UITableViewDataSource
extension FavoritePetListVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favPetlists.count>0 {
            return favPetlists.count
        }else{
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if favPetlists.count == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoItemTableViewCell") as? NoItemTableViewCell else { return UITableViewCell() }
            cell.btnSelect.addTarget(self, action: #selector(selectButtonAction(_:)), for: .touchUpInside)

            return cell
            }else{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PetListTableViewCell") as? PetListTableViewCell else { return UITableViewCell() }
        let favPetModel = favPetlists[indexPath.row]
        cell.favPetModel = favPetModel
        cell.btnOption.addTarget(self, action: #selector(optionButtonAction(_:)), for: .touchUpInside)

        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

}
