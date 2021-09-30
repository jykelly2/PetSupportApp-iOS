//
//  FutureScheduleList.swift
//  PetSupportApp
//
//  Created by Enam on 8/15/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD

class ScheduleListTableViewCell: UITableViewCell {
    //MARK:- UIControl's Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var lblPetName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnOption: UIButton!

    
    func setValues(value:Schedule){
        lblPetName.text = value.animalName
        lblStatus.text = value.status
        if value.status == "Approved" {
            statusView.backgroundColor = .blue
        }else if value.status == "Reviewing" {
            statusView.backgroundColor = .red
        }else if value.status == "In Progress" {
            statusView.backgroundColor = .yellow
        }else if value.status == "Cancelled" {
            statusView.backgroundColor = .gray
        }else if value.status == "Completed" {
            statusView.backgroundColor = .green
        }
        let sep = value.date.components(separatedBy: "T")
        lblTime.text = sep[0]
        
        getImages(imageArray: value.animalPicture)
     
    }
    
    override func layoutSubviews() {
        petImageView.layer.cornerRadius = 10
        petImageView.clipsToBounds = true
        
        statusView.layer.cornerRadius = statusView.frame.height/2
        statusView.clipsToBounds = true
    }
    func getImages(imageArray:[String]) {
        
        let params:[String:Any] = ["bucket":"Animal","pictures":imageArray]
        Alamofire.request("https://petsupportapp.com/api/images/getImageUrls/", method:.post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            if response.result.isSuccess {
                let data : JSON = JSON(response.result.value!)
                self.parseImage(json: data)
            }else {
                print(response.result.error!.localizedDescription)
            }
        }
    }
    func parseImage(json:JSON){
        var images = [String]()
        for item in json {
            if let myItem = item.1.string {
                    images.append(myItem)
            }
        }
        if let url = URL(string: images[0]){
            petImageView.sd_setImage(with: url, completed: nil)
        }
    }
}

class ScheduleList: UIViewController, ScheduleOptionVCDelegate {
    
    

    
    func didScheduleOptionClose(_ isSelect: Bool) {
        if let parent = self.parent?.parent as? ScheduleVC{
            parent.hidefadeView()
        }
    }
    
    //MARK:- UIControl's Outlets
    @IBOutlet weak var tblSchedule: UITableView!
    @IBOutlet weak var lblTotalItems: UILabel!
    
    //MARK:- Class Variables
    
    var scheduleLists = [Schedule]()
    var currentSchedule = [Schedule]()
    var futureSchedule = [Schedule]()
    var pastSchedule = [Schedule]()
    var scheduleType : SCHEDULE_TYPE = .Future

    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
      
    }
    override func viewDidLayoutSubviews() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let parent = self.parent?.parent as? ScheduleVC{
            getBookingList()
            switch self.scheduleType {
                
            case .Future:
               // self.page = 1
                parent.selectIndex = 0
                parent.setViewSelection(index: 0)

                break
            case .Past:
               // self.page = 1
                parent.selectIndex = 1
                parent.setViewSelection(index: 1)
                break
            }
        }
    }
       
    //MARK:- Custome Methods
        
    func configureUI(){
        tblSchedule.rowHeight = 150
    }

    
    //MARK:- Action Methods
    @objc func optionButtonAction(_ sender:UIButton){
        
        let vc = SSchedule.instantiateViewController(withIdentifier: "ScheduleOptionVC") as! ScheduleOptionVC
        self.addChild(vc)
        vc.scheduleListModel = currentSchedule[sender.tag]
        vc.delegate = self
        vc.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
        if let parent = self.parent?.parent as? ScheduleVC{
            parent.showfadeView()
        }
    }
    
    @objc func selectButtonAction(_ sender:UIButton){
    }
  
    func btnSelected(sender: UIButton,bookingId: String) {
        if sender.tag == 4 {
            let alert = UIAlertController(title: "Pet Support", message: "Are you sure you would like to cancel schedule", preferredStyle: .alert)
            let action = UIAlertAction(title: "Yes", style: .default) { (action) in
                self.cancelBooking(bookingId:bookingId)
            }
            let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

//MARK:- UITableViewDelegate,UITableViewDataSource
extension ScheduleList:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentSchedule.count>0 {
            return currentSchedule.count
        }else{
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentSchedule.count == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoItemTableViewCell") as? NoItemTableViewCell else { return UITableViewCell() }
            cell.btnSelect.addTarget(self, action: #selector(selectButtonAction(_:)), for: .touchUpInside)

            return cell
            }else{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleListTableViewCell") as? ScheduleListTableViewCell else { return UITableViewCell() }
        let scheduleListModel = currentSchedule[indexPath.row]
        cell.setValues(value: scheduleListModel)
        cell.btnOption.tag = indexPath.row
        cell.btnOption.addTarget(self, action: #selector(optionButtonAction(_:)), for: .touchUpInside)

        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let scheduleListModel = currentSchedule[indexPath.row]
         let vc = SSchedule.instantiateViewController(withIdentifier: "ScheduleDetailVC") as! ScheduleDetailVC
            vc.scheduleListModel = scheduleListModel
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
extension ScheduleList {
    func getBookingList(){
        KRProgressHUD.show()
        Alamofire.request("https://petsupportapp.com/api/bookings/client/\(USER_ID)", method: .get).responseJSON { (response) in
            if response.result.isSuccess {
                let data :JSON = JSON(response.result.value!)
                print(data)
                self.parseData(json: data["bookings"])
            }
        }
    }
    func parseData(json:JSON){
        pastSchedule.removeAll()
        futureSchedule.removeAll()
        currentSchedule.removeAll()
        
        for item in json {
            let status = item.1["status"].string ?? ""
            let date = item.1["date"].string ?? ""
            let _id = item.1["_id"].string ?? ""
            let animalId = item.1["animal"]["_id"].string ?? ""
            let animalName = item.1["animal"]["name"].string ?? ""
            var animalPics = [String]()
            if let pictures =  item.1["animal"]["pictures"].array {
                for pic in pictures {
                    animalPics.append(pic.string ?? "")
                }
            }
            let sepDate = date.components(separatedBy: "T")
            let eventDate = sepDate[0]
            let todaysDate = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let resultDate = formatter.string(from: todaysDate)
            if  eventDate >= resultDate{
                let data = Schedule(animalId: animalId, animalName: animalName, animalPicture: animalPics, date: date, id: _id, status: status)
                self.futureSchedule.append(data)
            }else {
                let data = Schedule(animalId: animalId, animalName: animalName, animalPicture: animalPics, date: date, id: _id, status: status)
                self.pastSchedule.append(data)
            }
         
        }
        switch self.scheduleType {
            
        case .Future:
            self.currentSchedule = futureSchedule
            self.tblSchedule.reloadData()
            lblTotalItems.text = "\(currentSchedule.count) Bookings"
            if currentSchedule.count <= 0 {
                tblSchedule.isHidden = true
            }
            break
        case .Past:
            self.currentSchedule = pastSchedule
            self.tblSchedule.reloadData()
            lblTotalItems.text = "\(currentSchedule.count) Bookings"
            if currentSchedule.count <= 0 {
                tblSchedule.isHidden = true
            }
            break
        }
        KRProgressHUD.dismiss()
    }
    func cancelBooking(bookingId:String){
        let params = ["status":"Cancelled"]
        Alamofire.request("https://petsupportapp.com/api/bookings/client/cancel/\(bookingId)", method: .post, parameters: params).responseJSON { (response) in
            if response.result.isSuccess {
                let res:JSON = JSON(response.result.value!)
                print(res)
                let alert = UIAlertController(title: "Pet Support", message: res.string ?? "", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                    self.tabBarController?.selectedIndex = 0
                    //self.navigationController?.popToRootViewController(animated: true)
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
}




/*
 "animal" : {
   "_id" : "60c2cacb80a9414c40a7171b",
   "name" : "Bruno",
   "pictures" : [
     "profile-image\/6ClFwQ||FrenchBulldog1.jpeg",
     "animal-pictures\/mha95p||FrenchBulldog3.jpeg",
     "animal-pictures\/NUhxZR||FrenchBulldog4.jpeg",
     "animal-pictures\/KSLe77||FrenchBulldog2.jpeg"
   ]
 },
 "status" : "Completed",
 "date" : "2021-03-15T00:00:00.000Z",
 "_id" : "60c823db67811df9a1e33ca3"
},
 */
