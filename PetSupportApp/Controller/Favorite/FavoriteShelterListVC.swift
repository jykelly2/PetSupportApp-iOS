//
//  ShelterListVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/13/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit
class ShelterListTableViewCell: UITableViewCell {
    //MARK:- UIControl's Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shelterImageView: UIImageView!
    @IBOutlet weak var lblShelterName: UILabel!
    @IBOutlet weak var btnOption: UIButton!

     var favShelterModel: FavShelterModel? {
        didSet{
            if let _favShelterModel = favShelterModel {
                lblShelterName.text = _favShelterModel.shelterName
                shelterImageView.image = UIImage(named: _favShelterModel.shelterImage)
            }
        }
    }
    
    override func layoutSubviews() {
    }
}


class FavoriteShelterListVC: UIViewController  {
    //MARK:- UIControl's Outlets
    @IBOutlet weak var tblFavoriteShelter: UITableView!

    //MARK:- Class Variables
    let viewModel = PetViewModel()
    var favShelterlists:[FavShelterModel] = []

    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    override func viewDidLayoutSubviews() {
    }
       
    //MARK:- Custome Methods
    
    func configureUI(){
        favShelterlists = viewModel.favShelterList
    }

    
    //MARK:- Action Methods
    @objc func optionButtonAction(_ sender:UIButton){
        
        let vc = SFavorite.instantiateViewController(withIdentifier: "ShelterFavOptionPopUpVC") as! ShelterFavOptionPopUpVC
        self.addChild(vc)
        vc.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
        
    }
    @objc func selectButtonAction(_ sender:UIButton){
    }

}

//MARK:- UITableViewDelegate,UITableViewDataSource
extension FavoriteShelterListVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favShelterlists.count>0 {
            return favShelterlists.count
        }else{
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if favShelterlists.count == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoItemTableViewCell") as? NoItemTableViewCell else { return UITableViewCell() }
            cell.btnSelect.addTarget(self, action: #selector(selectButtonAction(_:)), for: .touchUpInside)

            return cell
        }else{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShelterListTableViewCell") as? ShelterListTableViewCell else { return UITableViewCell() }
        let favShelterModel = favShelterlists[indexPath.row]
        cell.favShelterModel = favShelterModel
        cell.btnOption.addTarget(self, action: #selector(optionButtonAction(_:)), for: .touchUpInside)

        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

}
