//
//  ConfirmScheduleVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/15/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON
import KRProgressHUD

class ConfirmScheduleVC: UIViewController,MKMapViewDelegate {
    //MARK:- UIControl's Outlets
    @IBOutlet weak var lblMeetPet: UILabel!
    @IBOutlet weak var lblPetDescription: UILabel!
    @IBOutlet weak var animalImage: UIImageView!
    
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
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    
    
    
    //MARK:- Class Variables
    var selectedAnimal:Animal?
    var selectedDate = ""
    var startTime = ""
    var endTime = ""
    var timesArray = [String]()
    var hours : Double?
    var mins : Double?
    var totalAmount = 0
    
    let userLocation = CLLocationCoordinate2D()
  //  var locationManager = CLLocationManager()
    lazy var geoCoder = CLGeocoder()
    
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
        if let pet = selectedAnimal {
            self.getImages(imageArray: pet.pictures)
            mapView.delegate = self
            timesArray.append(self.startTime)
            timesArray.append(self.endTime)
            lblMeetPet.text = pet.name
            lblPetDescription.text = pet.breed
            lblDate.text = self.selectedDate
            lblStartDate.text = self.startTime
            lblEndtime.text = self.endTime
            let totalTimeis = findDateDiff(time1Str: self.startTime, time2Str: self.endTime)
            lblTotalTime.text = totalTimeis
            let intHours = Int(hours ?? 0)
            let intMins = Int(mins ?? 0)
            if intMins <= 30 && intHours == 0{
                print("condition 1")
                lblTotalFees.text = "CA$ 05.00"
                self.totalAmount = 05
            }else if intHours >= 1 && (intMins <= 30 && intMins >= 1){
                print("condition 2")
                let one = Int(hours!) * 10
                let two = one + 5
                lblTotalFees.text = "CA$ \(two).00"
                self.totalAmount = two
            }else if intHours >= 1 && intMins == 0 {
                print("condition 3")
                let one = Int(hours!) * 10
                lblTotalFees.text = "CA$ \(one).00"
                self.totalAmount = one
            }else if intHours >= 1 && (intMins <= 59 && intMins >= 31) {
                let one = Int(hours!) * 10
                let two = one + 10
                lblTotalFees.text = "CA$ \(two).00"
                self.totalAmount = two
            }
            let str = String(CARD_NUM)
            let last4 = str.suffix(4)
            lblcardLastfourDigit.text = "...\(last4)"
            
            lblShelterName.text = pet.shelter.name
            lblShelterAddress.text = "\(pet.shelter.address), \(pet.shelter.postalCode), \(pet.shelter.city), \(pet.shelter.province)"
            lblShelterPhone.text = pet.shelter.phoneNumber
            
            let adress = "\(pet.shelter.address),\(pet.shelter.city),\(pet.shelter.province)"
            print("this is address of shelter = \(adress)")
            geoCoder.geocodeAddressString(adress) { (placemarks, error) in
                self.processResponse(withPlacemarks: placemarks, error: error)
            }
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
                annotation.title = selectedAnimal?.shelter.name
                self.mapView.addAnnotation(annotation)
                
                
            } else {
                print("No Matching Location Found")
            }
        }
    }
    func findDateDiff(time1Str: String, time2Str: String) -> String {
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "hh:mm a"

        guard let time1 = timeformatter.date(from: time1Str),
            let time2 = timeformatter.date(from: time2Str) else { return "" }

        //You can directly use from here if you have two dates

        let interval = time2.timeIntervalSince(time1)
        let hour = interval / 3600;
        let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
     //   let intervalInt = Int(interval)
        self.hours = hour
        self.mins = minute
        return "\(Int(hour)) Hours \(Int(minute)) Minutes"
    }
    func makeCircle(){
        
        btnCancel.layer.cornerRadius = btnCancel.frame.height/2
        btnCancel.clipsToBounds = true
        btnCancel.layer.borderColor = UIColor.init(rgb: 0xE62BFF).cgColor
        btnCancel.layer.borderWidth = 1
        
        btnEdit.layer.cornerRadius = btnCancel.frame.height/2
        btnEdit.clipsToBounds = true
                
    }
    
   
    //MARK:- Action Methods

    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
            
    @IBAction func scheduleOptionButtonAction(_ sender: UIButton) {
        
        let vc = SSchedule.instantiateViewController(withIdentifier: "ScheduleOptionVC") as! ScheduleOptionVC
        self.addChild(vc)
    //    vc.scheduleListModel = self.selectedAnimal
        vc.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
        
    }
    
    
    @IBAction func editButtonAction(_ sender: UIButton) {
        if let pet = selectedAnimal {
            let intHours = Int(hours ?? 0)
            let intMins = Int(mins ?? 0)
            addBooking(shelter: pet.shelter.shelterId, client: USER_ID, animal: pet.id, date: self.selectedDate, startTime: self.startTime, endTime: self.endTime,hours:"\(intHours).\(intMins)", totalAmount: self.totalAmount)
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}

extension ConfirmScheduleVC {
 
    func addBooking(shelter:String,client:String,animal:String,date:String,startTime:String,endTime:String,hours:String,totalAmount:Int){
        let params : [String : Any] = ["shelter":shelter,"client":client,"animal":animal,"date":date,"startTime":startTime,"endTime":endTime,"hours":hours,"totalAmount":totalAmount,"status":"Reviewing"]
        Alamofire.request("https://petsupportapp.com/api/bookings/client/add", method: .post, parameters: params).responseJSON { (response) in
            if response.result.isSuccess {
                let data : JSON = JSON(response.result.value!)
                print(data)
                let alert = UIAlertController(title: "Pet Support", message: data.string ?? "", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (action) in
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
}
