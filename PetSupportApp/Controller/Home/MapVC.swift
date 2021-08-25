//
//  MapVC.swift
//  PetSupportApp
//
//  Created by Enam on 8/9/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    //MARK:- UIControl's Outlets
    @IBOutlet private var mapView: MKMapView!
    @IBOutlet private var filterView: UIView!
    @IBOutlet private var shelterListView: UIView!
    @IBOutlet private var topView: UIView!
    @IBOutlet private var lblTotalShelter: UILabel!

    //MARK:- Class Variables
    // Create a location manager to trigger user tracking
    let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        return manager
    }()
    
    //MARK:- View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Map Search"
       // setupCompassButton()
       // setupUserTrackingButtonAndScaleView()
        registerAnnotationViewClasses()
        loadDataForMapRegionAndBikes()
        self.updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        self.makeRoundView()
    }
    
    //MARK:- Custome Methods
    
    func updateUI(){
        
    }
    
    func makeRoundView(){
        topView.layer.cornerRadius = 10
        topView.clipsToBounds = true

        filterView.layer.cornerRadius = 10
        filterView.clipsToBounds = true
        
        shelterListView.layer.cornerRadius = 10
        shelterListView.clipsToBounds = true
    }
    
    func setupCompassButton() {
        let compass = MKCompassButton(mapView: mapView)
        compass.compassVisibility = .visible
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: compass)
        mapView.showsCompass = false
    }

    func setupUserTrackingButtonAndScaleView() {
        mapView.showsUserLocation = true
        
        let button = MKUserTrackingButton(mapView: mapView)
        button.layer.backgroundColor = UIColor(white: 1, alpha: 0.8).cgColor
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        let scale = MKScaleView(mapView: mapView)
        scale.legendAlignment = .trailing
        scale.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scale)
        
        NSLayoutConstraint.activate([button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
                                     button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                                     scale.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -10),
                                     scale.centerYAnchor.constraint(equalTo: button.centerYAnchor)])
    }
    
    func registerAnnotationViewClasses() {
        mapView.register(ShelterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    func loadDataForMapRegionAndBikes() {
        if let plist = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Data", ofType: "plist")!) {
            if let region = plist["region"] as? [NSNumber] {
                let coordinate = CLLocationCoordinate2D(latitude: region[0].doubleValue, longitude: region[1].doubleValue)
                let span = MKCoordinateSpan(latitudeDelta: region[2].doubleValue, longitudeDelta: region[3].doubleValue)
                mapView.region = MKCoordinateRegion(center: coordinate, span: span)
            }
            if let shelters = plist["shelters"] as? [[String : NSNumber]] {
                mapView.addAnnotations(ShelterAnnotation.shelters(fromDictionaries: shelters))
            }
        }
    }
    
    @IBAction func filterButtonAction(_ sender: UIButton) {
        let destVC:FilterVC!  = SHome.instantiateViewController(withIdentifier: "FilterVC") as? FilterVC
        destVC.modalPresentationStyle = .fullScreen
        self.present(destVC, animated: true, completion: nil)
    }
    
    
    @IBAction func shelterListButtonAction(_ sender: UIButton) {
        let destVC:ShelterRescueModalVC!  = SHome.instantiateViewController(withIdentifier: "ShelterRescueModalVC") as? ShelterRescueModalVC
        //destVC.delegate = self
        self.addChild(destVC)
        destVC.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(destVC.view)
        destVC.didMove(toParent: self)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
