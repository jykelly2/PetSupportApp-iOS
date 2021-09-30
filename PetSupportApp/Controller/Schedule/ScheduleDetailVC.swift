//
//  ScheduleDetailVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/15/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import MapKit

class ScheduleDetailVC: UIViewController {
    //MARK:- UIControl's Outlets
    @IBOutlet weak var lblMeetPet: UILabel!
    @IBOutlet weak var lblPetDescription: UILabel!
    
    @IBOutlet weak var animalImage: UIImageView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var statusIconView: UIView!
    @IBOutlet weak var lblProgress: UILabel!
    @IBOutlet weak var lbldateTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStartTimeTitle: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblFees: UILabel!
    @IBOutlet weak var lblTotalTime: UILabel!
    @IBOutlet weak var lblTotalTimeTitle: UILabel!
    @IBOutlet weak var lblEndtime: UILabel!
    @IBOutlet weak var lblEndTimeTitle: UILabel!
    
    @IBOutlet weak var lblTotalFees: UILabel!
    @IBOutlet weak var lblcardLastfourDigit: UILabel!
    @IBOutlet weak var lblShelterName: UILabel!
    @IBOutlet weak var lblShelterAddress: UILabel!
    @IBOutlet weak var lblShelterPhone: UILabel!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    
    //MARK:- Class Variables
    var scheduleListModel:Schedule!
    lazy var geoCoder = CLGeocoder()
    var shelterId  = ""
    //MARK:- View life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        makeCircle()
    }
    
    //MARK:- Custome Methods
    func setupUI(){
        if let value = scheduleListModel {
        if value.status == "Approved" {
            statusIconView.backgroundColor = .blue
        }else if value.status == "Reviewing" {
            statusIconView.backgroundColor = .red
        }else if value.status == "In Progress" {
            statusIconView.backgroundColor = .yellow
        }else if value.status == "Cancelled" {
            statusIconView.backgroundColor = .gray
        }else if value.status == "Completed" {
            statusIconView.backgroundColor = .green
        }
      
            lblMeetPet.text =  value.animalName
            lblProgress.text =  value.status
            self.getImages(imageArray: value.animalPicture)
            self.getbookingDetails(id: value.id)
        }
        
    }
    
    func makeCircle(){
        
        btnCancel.layer.cornerRadius = btnCancel.frame.height/2
        btnCancel.clipsToBounds = true
        btnCancel.layer.borderColor = UIColor.init(rgb: 0xE62BFF).cgColor
        btnCancel.layer.borderWidth = 1
        
       
        
        statusIconView.layer.cornerRadius = statusIconView.frame.height/2
        statusIconView.clipsToBounds = true
        
    }
    
   
    //MARK:- Action Methods

    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
            
    @IBAction func scheduleOptionButtonAction(_ sender: UIButton) {
        
        let vc = SSchedule.instantiateViewController(withIdentifier: "ScheduleOptionVC") as! ScheduleOptionVC
        self.addChild(vc)
        vc.scheduleListModel = self.scheduleListModel
        vc.shelterId = self.shelterId
        vc.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
        
    }
    
    
    @IBAction func editButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Pet Support", message: "Are you sure you would like to cancel schedule", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.cancelBooking(bookingId:self.scheduleListModel.id)
        }
        let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    func cancelBooking(bookingId:String){
        let params = ["status":"Cancelled"]
        Alamofire.request("https://petsupportapp.com/api/bookings/client/cancel/\(bookingId)", method: .post, parameters: params).responseJSON { (response) in
            if response.result.isSuccess {
                let res:JSON = JSON(response.result.value!)
                print(res)
                let alert = UIAlertController(title: "Pet Support", message: res.string ?? "", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                   // self.tabBarController?.selectedIndex = 0
                    self.navigationController?.popToRootViewController(animated: true)
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            }
        }
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
      var petImages = [String]()
        for item in json {
            if let myItem = item.1.string {
                    petImages.append(myItem)
            }
        }
        if let url = URL(string: petImages[0]){
            self.animalImage.sd_setImage(with: url, completed: nil)
        }
    }
    
    
    func getbookingDetails(id:String){
        Alamofire.request("https://petsupportapp.com/api/bookings/client/detail/\(id)", method: .get).responseJSON { (response) in
            if response.result.isSuccess {
                let data:JSON = JSON(response.result.value!)
                self.setValues(json: data)
            }
        }
    }
    func setValues(json:JSON){
        let startTime = json["startTime"].string ?? ""
        let endTime = json["endTime"].string ?? ""
        let totalTime = json["hours"].double ?? 0.0
        let totalAmmount = json["totalAmount"].int ?? 0
        
        let startTime2 = startTime.components(separatedBy: "T")
        let endTime2 = endTime.components(separatedBy: "T")
        self.lblStartDate.text = startTime2[1]
        self.lblEndtime.text = endTime2[1]
        self.lblTotalTime.text = "\(totalTime) Hours"
        self.lblTotalFees.text = "CA$ \(totalAmmount)"
        
        let sheltername = json["shelter"]["name"].string ?? ""
        let streetAddress = json["shelter"]["streetAddress"].string ?? ""
        let city = json["shelter"]["city"].string ?? ""
        let phoneNumber = json["shelter"]["phoneNumber"].string ?? ""
        let shelterId = json["shelter"]["_id"].string ?? ""
        self.shelterId = shelterId
        self.lblShelterPhone.text = phoneNumber
        self.lblShelterAddress.text = "\(sheltername) \(streetAddress) \(city)"
        let address = "\(sheltername) \(streetAddress) \(city)"
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
    }
    func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        
        if let error = error {
            print("Unable to Forward Geocode Address (\(error))")
            
            
        } else {
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                let coordinate = location.coordinate
                
                print("this is \(coordinate.latitude), \(coordinate.longitude)")
                let latitude = coordinate.latitude
                let longitude = coordinate.longitude
                let lonDelta :CLLocationDegrees = 0.05
                let letDelta : CLLocationDegrees = 0.05
                let span = MKCoordinateSpan(latitudeDelta: letDelta, longitudeDelta: lonDelta)
                let userLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let region = MKCoordinateRegion(center: userLocation, span: span)
                
                self.mapView.setRegion(region, animated: true)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = userLocation
                annotation.title = self.scheduleListModel.animalName
                self.mapView.addAnnotation(annotation)
                
                
            } else {
                print("No Matching Location Found")
            }
        }
    }
}

