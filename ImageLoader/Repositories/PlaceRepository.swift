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
        return sessionManager.execute(GooglePlacesRequest.Search(types: types, location: location, radius: radius)).then { $0.data }
    }
    
    func loadFavorites() -> Promise<[Place]> {
        return Promise { [unowned self] fulfill, reject in
            self.context.perform {
                do {
                    let results = try self.context.fetch(PlaceMO.fetchRequest(configured: { request in
                        request.includesPropertyValues = true
                    }))
                    let places = results.map { mo in
                        return Place(id: mo.id!,
                                     name: mo.name!,
                                     icon: mo.icon!,
                                     types: [],
                                     location: Location(latitude: mo.latitude, longitude: mo.longitude),
                                     address: mo.address!,
                                     photoRef: mo.photoRef!)
                    }
                    fulfill(places)
                } catch {
                    reject(error)
                }
            }
        }
    }
    
    func addToFavorites(_ place: Place) -> Promise<Void> {
        guard try! context.fetch(PlaceMO.fetchRequest(configured: { request in
            request.includesPropertyValues = false
            request.predicate = NSPredicate(format: "id == %@", place.id)
        })).isEmpty else {
            return Promise()
        }
        return Promise { [unowned self] fulfill, reject in
            self.context.perform {
                do {
                    let placeMO: PlaceMO = self.context.new()
                    placeMO.address = place.address
                    placeMO.id = place.id
                    placeMO.latitude = place.coordinate.latitude
                    placeMO.longitude = place.coordinate.longitude
                    placeMO.name = place.name
                    placeMO.icon = place.icon
                    placeMO.photoRef = place.photos.last?.reference
                    try self.context.save()
                    fulfill(())
                } catch {
                    reject(error)
                }
            }
        }
    }
}
