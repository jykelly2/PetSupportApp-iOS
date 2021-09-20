//
//  AccountVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/17/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit
import CoreLocation
import KRProgressHUD
import Alamofire
import SwiftyJSON
import GoogleSignIn
import FacebookLogin
import FacebookCore
import AuthenticationServices

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

class AccountVC: UIViewController, SignInModalVCDelegate,CLLocationManagerDelegate ,ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func didSelectSignOption(_ controller: SignInModalVC, signInOption: Int) {
        switch signInOption {
        case 1:
            print("google")
            GIDSignIn.sharedInstance()?.presentingViewController = self
            
            // Automatically sign in the user.
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
            GIDSignIn.sharedInstance().delegate = self
            
            GIDSignIn.sharedInstance().signIn()
        case 2:
            print("facebook")
            let loginManager = LoginManager()
            loginManager.logOut()
            loginManager.logIn(permissions: [.publicProfile, .email], viewController: self) { (loginResult) in
                switch loginResult {
                case .failed(let error):
                    print(error)
                case .cancelled:
                    print("User cancelled login.")
                case .success( _, _, let accessToken):
                    let token = accessToken
                    print("Logged in!", token)
                    //self.strLogin = "2"
                    self.getUserProfile()
                }
            }
        case 3:
            print("apple")
            if #available(iOS 13.0, *) {
                let provider = ASAuthorizationAppleIDProvider()
                let request = provider.createRequest()
                request.requestedScopes = [.fullName, .email]
                let controller = ASAuthorizationController(authorizationRequests: [request])
                controller.delegate = self
                controller.presentationContextProvider = self
                controller.performRequests()
            }
        default:
            self.signIn()
        }
        
    }
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userLoc: UILabel!
    
    @IBOutlet weak var tblAccount: UITableView!
    
    var arrayAccountOptions = [Account]()
    var petPredModel = [PetPrefrences]()
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblAccount.rowHeight = 60
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        if LOGGED_IN == true {
            self.signIn(email: EMAIL)
        }
        if LOGGED_IN == false {
            
            topViewHeightConstraint.constant = 0
            tableViewHeight.constant = 260
            topView.isHidden = true
            updateArrayForNoSigninUsers()
        }else {
            topViewHeightConstraint.constant = 150
            tableViewHeight.constant = 360
            topView.isHidden = false
            updateArrayAccountOptions()
            userEmail.text = EMAIL
        }
    }
    
    override func viewDidLayoutSubviews() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
    }
    
    func updateArrayAccountOptions(){
        arrayAccountOptions.removeAll()
        arrayAccountOptions.append(Account(title: "Account Info", icon: "support-icon", identifier: "DashboardViewController"))
        
        arrayAccountOptions.append(Account(title: "Scheduler Profile", icon: "logout-icon", identifier: "PriceBondListViewController"))
        
        arrayAccountOptions.append(Account(title: "Payment", icon: "logout-icon", identifier: "PriceBondListViewController"))
        
        arrayAccountOptions.append(Account(title: "Setting & Info", icon: "logout-icon", identifier: "DrawResultViewController"))
        arrayAccountOptions.append(Account(title: "Feedback", icon: "support-icon", identifier: "ContactUsViewController"))
        arrayAccountOptions.append(Account(title: "Sign out", icon: "logout-icon", identifier: "SupportViewController"))
        
        
    }
    func updateArrayForNoSigninUsers(){
        arrayAccountOptions.removeAll()
        arrayAccountOptions.append(Account(title: "Adopter Profile", icon: "logout-icon", identifier: "PriceBondListViewController"))
        arrayAccountOptions.append(Account(title: "Setting & Info", icon: "logout-icon", identifier: "DrawResultViewController"))
        arrayAccountOptions.append(Account(title: "Feedback", icon: "support-icon", identifier: "ContactUsViewController"))
        arrayAccountOptions.append(Account(title: "Sign in", icon: "logout-icon", identifier: "SupportViewController"))
        
        tblAccount.reloadData()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[locations.count - 1]
        
        if userLocation.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
                if (error != nil){
                    print("error in reverseGeocode")
                }
                if placemarks != nil {
                    let placemark = placemarks! as [CLPlacemark]
                    if placemark.count > 0 {
                        let placemark = placemarks![0]
                        print(placemark.locality!)
                        print(placemark.administrativeArea!)
                        print(placemark.country!)
                        
                        self.userLoc.text = placemark.locality
                        
                        
                    }
                }
            }
        }
        
    }
    
    
    func signIn()  {
        let vc = SAccount.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
        // self.present(vc, animated: true, completion: nil)
    }
    
    func didSelectItem(_ index:Int){
        
        if LOGGED_IN == true {
            //user is loged in
            if index == 0 {
                let vc = SAccount.instantiateViewController(withIdentifier: "EditAcountVC") as! EditAcountVC
                let backItem = UIBarButtonItem()
                backItem.title = " "
                navigationItem.backBarButtonItem = backItem
                self.navigationController?.pushViewController(vc, animated: true)
            }else if index == 1 {
                let vc = SAccount.instantiateViewController(withIdentifier: "AdopterProfileVC") as! AdopterProfileVC
                let backItem = UIBarButtonItem()
                backItem.title = " "
                navigationItem.backBarButtonItem = backItem
                if petPredModel.count > 0 {
                    vc.petPrefModel = petPredModel[0]
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }else if index == 2 {
                let vc = SAccount.instantiateViewController(withIdentifier: "PaymentListVC") as! PaymentListVC
                let backItem = UIBarButtonItem()
                backItem.title = " "
                navigationItem.backBarButtonItem = backItem
                //                if petPredModel.count > 0 {
                //                    vc.petPrefModel = petPredModel[0]
                //                }
                self.navigationController?.pushViewController(vc, animated: true)
            }else if index == 3 {
                let vc = SAccount.instantiateViewController(withIdentifier: "SettingInfoVC") as! SettingInfoVC
                let backItem = UIBarButtonItem()
                backItem.title = " "
                navigationItem.backBarButtonItem = backItem
                self.navigationController?.pushViewController(vc, animated: true)
            }else if index == 4 {
                openAppStore()
            }else if index == 5 {
                UserDefaults.standard.removeObject(forKey:"firstName")
                UserDefaults.standard.removeObject(forKey: "lastName")
                UserDefaults.standard.removeObject(forKey: "userId")
                UserDefaults.standard.removeObject(forKey: "email")
                UserDefaults.standard.removeObject(forKey: "isLoggedIn")
                NAME = ""
                USER_ID = ""
                LOGGED_IN = false
                EMAIL = ""
                FIRST_NAME = ""
                LAST_NAME = ""
                simpleAlert("you are successfully logged out")
                tabBarController?.selectedIndex = 0
            }
        }else {
            //user is not loged in
            if index == 0 {
                gotoSignin()
            }else if index == 1 {
                let vc = SAccount.instantiateViewController(withIdentifier: "SettingInfoVC") as! SettingInfoVC
                let backItem = UIBarButtonItem()
                backItem.title = " "
                navigationItem.backBarButtonItem = backItem
                self.navigationController?.pushViewController(vc, animated: true)
            }else if index == 2 {
                openAppStore()
            }else if index == 3 {
                gotoSignin()
            }
        }
    }
    
    func openAppStore() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id284882215"),
           UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:]) { (opened) in
                if(opened){
                    print("App Store Opened")
                }
            }
        } else {
            print("Can't Open URL on Simulator")
        }
    }
    func gotoSignin(){
        let vc = SAccount.instantiateViewController(withIdentifier: "SignInModalVC") as! SignInModalVC
        self.addChild(vc)
        vc.delegate = self
        vc.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
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
            if EMAIL == "" || FIRST_NAME == "" || LAST_NAME == "" {
                cell.incompleBtnContainerV.backgroundColor = appPurple
                cell.btnIncompleteInfo.setTitleColor(UIColor.white, for: .normal)
                cell.btnIncompleteInfo.setTitle("INCOMPLETE", for: .normal)
            }else {
                cell.incompleBtnContainerV.backgroundColor = UIColor.green
                cell.btnIncompleteInfo.setTitleColor(UIColor.black, for: .normal)
                cell.btnIncompleteInfo.setTitle("COMPLETED", for: .normal)
            }
        }else if indexPath.row == 1 {
            if LOGGED_IN != false {
                cell.incompleBtnContainerV.isHidden = false
                if schedulerProfileCompleted == true{
                    cell.incompleBtnContainerV.backgroundColor = UIColor.green
                    cell.btnIncompleteInfo.setTitleColor(UIColor.black, for: .normal)
                    cell.btnIncompleteInfo.setTitle("COMPLETED", for: .normal)
                }else {
                    cell.incompleBtnContainerV.backgroundColor = appPurple
                    cell.btnIncompleteInfo.setTitleColor(UIColor.white, for: .normal)
                    cell.btnIncompleteInfo.setTitle("INCOMPLETE", for: .normal)
                }
            }else{
                
                cell.incompleBtnContainerV.isHidden = true
            }
        }else if indexPath.row == 2 {
            if LOGGED_IN != false {
                cell.incompleBtnContainerV.isHidden = false
                if paymentCardSaved == true{
                    cell.incompleBtnContainerV.backgroundColor = UIColor.green
                    cell.btnIncompleteInfo.setTitleColor(UIColor.black, for: .normal)
                    cell.btnIncompleteInfo.setTitle("COMPLETED", for: .normal)
                }else {
                    cell.incompleBtnContainerV.backgroundColor = appPurple
                    cell.btnIncompleteInfo.setTitleColor(UIColor.white, for: .normal)
                    cell.btnIncompleteInfo.setTitle("INCOMPLETE", for: .normal)
                }
            }else {
                cell.incompleBtnContainerV.isHidden = true
            }
        }
        else{
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
        if LOGGED_IN != false {
            if sender.tag == 0 {
                let vc = SAccount.instantiateViewController(withIdentifier: "EditAcountVC") as! EditAcountVC
                self.navigationController?.pushViewController(vc, animated: true)
            }else if sender.tag == 1 {
                let vc = SAccount.instantiateViewController(withIdentifier: "AdopterProfileVC") as! AdopterProfileVC
                if petPredModel.count > 0 {
                    vc.petPrefModel = petPredModel[0]
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }else if sender.tag == 2 {
                let vc = SAccount.instantiateViewController(withIdentifier: "PaymentListVC") as! PaymentListVC
                let backItem = UIBarButtonItem()
                backItem.title = " "
                navigationItem.backBarButtonItem = backItem
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayAccountOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func signIn(email:String) {
        KRProgressHUD.show()
        let params = ["email":email]
        Alamofire.request("https://petsupportapp.com/api/clients/login", method: .post, parameters: params).responseJSON { (response) in
            if response.result.isSuccess {
                let result:JSON = JSON(response.result.value!)
                print(result)
                self.parseSigninValues(json: result)
            }else {
                KRProgressHUD.dismiss()
                print(response.result.error!.localizedDescription)
            }
        }
    }
    func parseSigninValues(json:JSON){
        petPredModel.removeAll()
        let payment_CardSaved = json["paymentCardSaved"].bool ?? false
        let profile_Completed = json["profileCompleted"].bool ?? false
        let scheduler_ProfileCompleted = json["schedulerProfileCompleted"].bool ?? false
        let petPreference_Completed = json["petPreferenceCompleted"].bool ?? false
        paymentCardSaved = payment_CardSaved
        profileCompleted = profile_Completed
        schedulerProfileCompleted = scheduler_ProfileCompleted
        petPreferenceCompleted = petPreference_Completed
        KRProgressHUD.dismiss()
        tblAccount.reloadData()
        var breedArray = [String]()
        var trainingArray = [String]()
        if let breed = json["petPreference"]["breeds"].array {
            for b in breed {
                breedArray.append(b.string ?? "")
            }
        }
        if  let training = json["petPreference"]["training"].array {
            for t in training {
                trainingArray.append(t.string ?? "")
            }
        }
        
        
        let specialNeeds = json["petPreference"]["specialNeeds"].bool ?? false
        let age = json["petPreference"]["age"].string ?? ""
        let activeness = json["petPreference"]["activeness"].string ?? ""
        let animalType = json["petPreference"]["animalType"].string ?? ""
        let size = json["petPreference"]["size"].string ?? ""
        let gender = json["petPreference"]["gender"].string ?? ""
        let data = PetPrefrences(breed: breedArray, training: trainingArray, specialNeeds: specialNeeds, age: age, activeness: activeness, animalType: animalType, size: size, gender: gender)
        petPredModel.append(data)
    }
}

struct PetPrefrences {
    var breed : [String]
    var training:[String]
    var specialNeeds : Bool
    var age : String
    var activeness:String
    var animalType:String
    var size :String
    var gender :String
}
//MARK:- Google SignIn Delegates
extension AccountVC : GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            
            print("Gmail login success")
            print(user!)
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let name = user.profile.name
            let email = user.profile.email
            let userImageURL = user.profile.imageURL(withDimension: 200)
            // ...
            print(userImageURL!)
            print(userId!)
            print(idToken!)
            print(name!)
            print(email!)
            
            self.socialSignIn(email: email!, firstname: name!, lastname: userId!, profileImage: "\(userImageURL!)")
        }
    }
}
extension AccountVC {
    //MARK:- 3RD PARTY SIGNIN FUNCTIONS
    func getUserProfile () {
        let connection = GraphRequestConnection()
        _ = ""
        var email1 = ""
        var name1 = ""
        var img1 = ""
        var fbId = ""
        //var facebookToken =
        connection.add(GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email, first_name, last_name, picture.type(large),birthday, location{location{country, country_code}}"])) { (httpResponse, result, error) in
            print("result == ", result!)
            print("httpResponse == ", httpResponse!)
            let resposne = result as! NSDictionary
            if error == nil
            {
                
                if let picture = resposne.value(forKey: "picture") as? NSDictionary
                {
                    if let data = picture.value(forKey: "data") as? NSDictionary
                    {
                        if let url = data.value(forKey: "url") as? String
                        {
                            img1 = url
                            print("URL :=> \(url)")
                        }
                    }
                }
                
                if let id = resposne.value(forKey: "id") as? String
                {
                    print("ID :=> \(id)")
                    fbId = id
                }
                if let email = resposne.value(forKey: "email") as? String
                {
                    email1 = email
                    print("EMAIL :=> \(email)")
                }
                if let first_name = resposne.value(forKey: "first_name") as? String
                {
                    name1 = first_name
                    print("FIRST_NAME :=> \(first_name)")
                }
                if let last_name = resposne.value(forKey: "last_name") as? String
                {
                    name1 += last_name
                    print("LAST_NAME :=> \(last_name)")
                }
                self.socialSignIn(email: email1, firstname: name1, lastname: name1, profileImage: img1)
                //  self.signIn(type: "3", email: email1, image: img1, name: name1)
            }
            else{
                print("Graph Request Failed: \(error!.localizedDescription)")
            }
        }
        connection.start()
    }
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let credentials = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Get user's data
            // let authToken = String(data: credentials.identityToken!, encoding: .utf8)!
            let appleID = credentials.user
            var firstName = credentials.fullName?.givenName
            var lastName = credentials.fullName?.familyName
            var email = credentials.email
            let password = appleID
            
            
            if email == nil { email = appleID + "@apple.com" }
            var fullName = ""
            if firstName == nil { firstName = "" }
            if lastName == nil { lastName = "" }
            fullName = firstName! + " " + lastName!
            let username = firstName!.lowercased() + lastName!.lowercased()
            
            print("** APPLE **:\nUSERNAME: \(username)\nPASSWORD: \(password)\nEMAIL: \(String(describing: email!))\nFULL NAME: \(fullName)\n--------------------")
            
            self.socialSignIn(email: email ?? "", firstname: firstName ?? "", lastname: lastName ?? "", profileImage: "")
            
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in using an existing iCloud Keychain credential.
            _ = passwordCredential.user
            _ = passwordCredential.password
            
            //Navigate to other view controller
        } // ./ If credentials OK
    }
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        KRProgressHUD.dismiss()
        print("ERROR: \(error)")
    }
    
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    func socialSignIn(email:String,firstname:String,lastname:String,profileImage:String) {
        KRProgressHUD.show()
        let params = ["email":email,"firstname":firstname,"lastname":lastname,"profileImage":profileImage]
        Alamofire.request("https://petsupportapp.com/api/clients/register", method: .post, parameters: params).responseJSON { (response) in
            if response.result.isSuccess {
                let result:JSON = JSON(response.result.value!)
                print(result)
                self.parseSocialSigninValues(json: result)
                
                
            }else {
                KRProgressHUD.dismiss()
                print(response.result.error!.localizedDescription)
            }
        }
    }
    func parseSocialSigninValues(json:JSON){
        let firstname = json["firstname"].string ?? ""
        let lastname = json["lastname"].string ?? ""
        let userid = json["_id"].string ?? ""
        let email = json["email"].string ?? ""
        
        UserDefaults.standard.setValue(firstname, forKey: "firstName")
        UserDefaults.standard.setValue(lastname, forKey: "lastName")
        UserDefaults.standard.setValue(userid, forKey: "userId")
        UserDefaults.standard.setValue(email, forKey: "email")
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        NAME = "\(firstname) \(lastname)"
        USER_ID = userid
        LOGGED_IN = true
        EMAIL = email
        FIRST_NAME = firstname
        LAST_NAME = lastname
        KRProgressHUD.dismiss()
        let alert = UIAlertController(title: "Pet Support", message: "You have successfully signed in", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.tabBarController?.selectedIndex = 0
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
}
