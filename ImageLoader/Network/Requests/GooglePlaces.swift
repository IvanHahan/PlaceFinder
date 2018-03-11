//
//  Places.swift
//  ImageLoader
//
//  Created by Ivan Hahanov on 3/11/18.
//  Copyright © 2018 Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreLocation

private let baseUrl = "https://maps.googleapis.com/maps/api/place"
private let apiKey = "AIzaSyAU4-yR82XU7l4B_4i4zHlP0j3dWEk0IbU"

extension CLLocationCoordinate2D {
    var parameterStringRepresentation: String {
        return "\(latitude),\(longitude)"
    }
}

enum GooglePlacesRequest {
    
    struct Search: DecodableResultRequest {
        
        
        typealias Model = [Place]
        
        var path: String {
            return "/nearbysearch/json?"
        }
        
        var queryParameters: [String : String]? {
            return [
                "key": key,
                "location": location.parameterStringRepresentation,
                "radius": radius.description,
                "types": types.joined(separator: ",")
            ]
        }
        
        let key: String = apiKey
        let types: [String]
        let location: CLLocationCoordinate2D
        let radius: Int
        
        init(types: [String], location: CLLocationCoordinate2D, radius: Int = 500) {
            self.types = types
            self.location = location
            self.radius = radius
        }
    }
}
