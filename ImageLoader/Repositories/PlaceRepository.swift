//
//  PlaceRepository.swift
//  ImageLoader
//
//  Created by Ivan Hahanov on 3/10/18.
//  Copyright © 2018 Ivan Hahanov. All rights reserved.
//

import Foundation
import ReSwift
import CoreData
import Promise
import CoreLocation

class PlaceRepository {
    private let context: NSManagedObjectContext
    private let sessionManager: SessionManager
    
    static var shared: PlaceRepository!
    
    init(sessionManager: SessionManager,
         context: NSManagedObjectContext) {
        self.sessionManager = sessionManager
        self.context = context
    }
    
    func loadPlaces(types: [String], location: CLLocationCoordinate2D, radius: Int = 500) -> Promise<[Place]> {
        return sessionManager.execute(GooglePlacesRequest.Search(types: types, location: location, radius: radius))
    }
    
    
    
}
