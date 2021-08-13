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
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
}
/*
extension MapVC:MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

            if let marker = annotation as? MKMarkerAnnotationView{
                var view = mapView.dequeueReusableAnnotationView(withIdentifier: "marker") as? UserAnnotationView
                if view == nil {
    //Very IMPORTANT
                    print("nil for Marker")
                    view = UserAnnotationView(annotation: marker as? MKAnnotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
                }
                return view
            }else if let cluster = annotation as? MKClusterAnnotation{
                var view = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier) as? UserClusterAnnotationView
                if view == nil{
    //Very IMPORTANT
                    print("nil for Cluster")
                    view = UserClusterAnnotationView(annotation: cluster, reuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
                }
                return view
            }
            else{
                return nil
            }
        }
}

class UserAnnotationView: MKMarkerAnnotationView {
    static let preferredClusteringIdentifier = Bundle.main.bundleIdentifier! + ".UserAnnotationView"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = UserAnnotationView.preferredClusteringIdentifier
        collisionMode = .circle
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var annotation: MKAnnotation? {
        willSet {
            clusteringIdentifier = UserAnnotationView.preferredClusteringIdentifier
        }
    }
}


class UserClusterAnnotationView: MKAnnotationView {
    static let preferredClusteringIdentifier = Bundle.main.bundleIdentifier! + ".UserClusterAnnotationView"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        updateImage()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var annotation: MKAnnotation? { didSet { updateImage() } }

    private func updateImage() {
        if let clusterAnnotation = annotation as? MKClusterAnnotation {
            self.image = image(count: clusterAnnotation.memberAnnotations.count)
        } else {
            self.image = image(count: 1)
        }
    }

    func image(count: Int) -> UIImage {
        let bounds = CGRect(origin: .zero, size: CGSize(width: 40, height: 40))

        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { _ in
            // Fill full circle with tricycle color
          //  AppTheme.blueColor.setFill()
            UIBezierPath(ovalIn: bounds).fill()

            // Fill inner circle with white color
            UIColor.white.setFill()
            UIBezierPath(ovalIn: bounds.insetBy(dx: 8, dy: 8)).fill()

            // Finally draw count text vertically and horizontally centered
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.black,
                .font: UIFont.boldSystemFont(ofSize: 20)
            ]

            let text = "\(count)"
            let size = text.size(withAttributes: attributes)
            let origin = CGPoint(x: bounds.midX - size.width / 2, y: bounds.midY - size.height / 2)
            let rect = CGRect(origin: origin, size: size)
            text.draw(in: rect, withAttributes: attributes)
        }
    }
}
*/
