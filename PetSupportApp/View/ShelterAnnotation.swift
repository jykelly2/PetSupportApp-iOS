//  PetSupportApp
//
//  Created by Enam on 8/9/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import MapKit

class ShelterAnnotation: MKPointAnnotation {

    enum shelterType: Int {
        case type1
        case type2
    }
    
    var type: shelterType = .type2
    
    class func shelters(fromDictionaries dictionaries: [[String: NSNumber]]) -> [ShelterAnnotation] {
        let shelters = dictionaries.map { item -> ShelterAnnotation in
            let shelter = ShelterAnnotation()
            shelter.coordinate = CLLocationCoordinate2DMake(item["lat"]!.doubleValue, item["long"]!.doubleValue)
            shelter.type = shelterType(rawValue: item["type"]!.intValue)!
            return shelter
        }
        return shelters
    }

}
