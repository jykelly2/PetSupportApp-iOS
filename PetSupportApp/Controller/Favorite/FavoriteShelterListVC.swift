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
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblTotalShelter: UILabel!
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
       
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let parent = self.parent?.parent as? FavoriteVC{
            parent.selectIndex = 1
            parent.setViewSelection(index: 1)
        }
    }
    //MARK:- Custome Methods
    
    func configureUI(){
//        headerView.layer.borderWidth = 0.5
//        headerView.layer.borderColor = UIColor.black.cgColor
        
        favShelterlists = viewModel.favShelterList
        lblTotalShelter.text = "\(viewModel.favShelterList.count) Shelters"

    }

    
    //MARK:- Action Methods
    @objc func optionButtonAction(_ sender:UIButton){
        
        let vc = SFavorite.instantiateViewController(withIdentifier: "ShelterFavOptionPopUpVC") as! ShelterFavOptionPopUpVC
        self.addChild(vc)
        vc.favShelter = favShelterlists[sender.tag]
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
            return favShelterlists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShelterListTableViewCell") as? ShelterListTableViewCell else { return UITableViewCell() }
        let favShelterModel = favShelterlists[indexPath.row]
        cell.favShelterModel = favShelterModel
            cell.btnOption.tag = indexPath.row
        cell.btnOption.addTarget(self, action: #selector(optionButtonAction(_:)), for: .touchUpInside)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

}
