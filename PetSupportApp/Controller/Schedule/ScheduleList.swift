//
//  FutureScheduleList.swift
//  PetSupportApp
//
//  Created by Enam on 8/15/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

class ScheduleListTableViewCell: UITableViewCell {
    //MARK:- UIControl's Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var lblPetName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnOption: UIButton!

    var scheduleListModel: ScheduleListModel? {
       didSet{
           if let _scheduleListModel = scheduleListModel {
               lblPetName.text = _scheduleListModel.petName
               lblStatus.text = _scheduleListModel.petStatus.rawValue
               lblTime.text = _scheduleListModel.date
               petImageView.image = UIImage(named: _scheduleListModel.petImage)
            
            switch _scheduleListModel.petStatus {
            case .Approved:
                statusView.backgroundColor = .green
                break
            case .Reviewing:
                statusView.backgroundColor = .orange
            break

            case .InProgress:
                statusView.backgroundColor = .blue
            break
            }
           }
       }
   }
    
    override func layoutSubviews() {
        petImageView.layer.cornerRadius = 10
        petImageView.clipsToBounds = true
        
        statusView.layer.cornerRadius = statusView.frame.height/2
        statusView.clipsToBounds = true
    }
}

class ScheduleList: UIViewController {
    //MARK:- UIControl's Outlets
    @IBOutlet weak var tblSchedule: UITableView!

    //MARK:- Class Variables
    let viewModel = PetViewModel()
    var scheduleLists:[ScheduleListModel] = []

    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    override func viewDidLayoutSubviews() {
    }
       
    //MARK:- Custome Methods
    
    func configureUI(){
        tblSchedule.rowHeight = 150
        scheduleLists = viewModel.scheduleList
    }

    
    //MARK:- Action Methods
    @objc func optionButtonAction(_ sender:UIButton){
        
        let vc = SSchedule.instantiateViewController(withIdentifier: "ScheduleOptionVC") as! ScheduleOptionVC
        self.addChild(vc)
        vc.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
        
    }
    
    @objc func selectButtonAction(_ sender:UIButton){
    }
  

}

//MARK:- UITableViewDelegate,UITableViewDataSource
extension ScheduleList:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if scheduleLists.count>0 {
            return scheduleLists.count
        }else{
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if scheduleLists.count == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoItemTableViewCell") as? NoItemTableViewCell else { return UITableViewCell() }
            cell.btnSelect.addTarget(self, action: #selector(selectButtonAction(_:)), for: .touchUpInside)

            return cell
            }else{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleListTableViewCell") as? ScheduleListTableViewCell else { return UITableViewCell() }
        let scheduleListModel = scheduleLists[indexPath.row]
        cell.scheduleListModel = scheduleListModel
        cell.btnOption.addTarget(self, action: #selector(optionButtonAction(_:)), for: .touchUpInside)

        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let scheduleListModel = scheduleLists[indexPath.row]
         let vc = SSchedule.instantiateViewController(withIdentifier: "ScheduleDetailVC") as! ScheduleDetailVC
        vc.scheduleListModel = scheduleListModel
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
