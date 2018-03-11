//
//  Place.swift
//  ImageLoader
//
//  Created by Ivan Hahanov on 3/10/18.
//  Copyright © 2018 Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreLocation

struct Location: Decodable {
    let latitude: Double
    let longitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case latitude = "lng", longitude = "lat"
    }
}

struct Place: Decodable {
    let name: String
    let icon: URL
    let types: [String]
    let location: Location
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
    
    private enum CodingKeys: String, CodingKey {
        case name, icon, types, location = "geometry.location"
    }
}
