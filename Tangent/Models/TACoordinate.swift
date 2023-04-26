//
//  TACoordinate.swift
//  Tangent
//
//  Created by Vikram Singh on 4/24/23.
//

import Foundation
import MapKit

struct TACoordinate: Decodable {
    let latitude: Float
    let longitude: Float
    
    var clLocationCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: Double(self.latitude),
            longitude: Double(self.longitude)
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case latitude = "Latitude"
        case longitude = "Longitude"
    }
}
