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
        case latitude = "lat", longitude = "lng"
    }
}

struct Geometry: Decodable {
    let location: Location
    
    private enum CodingKeys: String, CodingKey {
        case location
    }
}

struct Place: Decodable, Equatable, Hashable {
    let id: String
    let name: String
    let icon: URL
    let types: [String]
    let geometry: Geometry
    let address: String?
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: geometry.location.latitude, longitude: geometry.location.longitude)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, icon, types, geometry, address = "vicinity"
    }
    
    public static func ==(lhs: Place, rhs: Place) -> Bool {
        return lhs.id == rhs.id
    }
    
    var hashValue: Int {
        return id.hashValue
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        icon = try container.decode(URL.self, forKey: .icon)
        types = try container.decode([String].self, forKey: .types)
        geometry = try container.decode(Geometry.self, forKey: .geometry)
        address = try? container.decode(String.self, forKey: .address)
    }
}
