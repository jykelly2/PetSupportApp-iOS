//  PetSupportApp
//
//  Created by Enam on 8/9/21.
//  Copyright © 2021 Jun K. All rights reserved.
//
import MapKit

class ShelterAnnotationView: MKMarkerAnnotationView {

    override var annotation: MKAnnotation? {
        willSet {
                clusteringIdentifier = "shelter"
                markerTintColor = UIColor(rgb: 0x760881)
                displayPriority = .defaultHigh
        }
    }
}
