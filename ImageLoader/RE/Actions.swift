//
//  Actions.swift
//  CoreDataNetworkLayer
//
//  Created by Ivan Hahanov on 2/16/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import CoreLocation
import ReSwift

struct Loading: Action {}
struct Failure: Action { let error: Error }
struct Dumb: Action {}

enum MapAction {
    
    struct UpdateLocation: Action {
        let location: CLLocation
    }
    
    struct UpdatePlaces: Action {
        let places: [Place]
    }
    
    static func requestLocationAuthorization(state: AppState, store: Store<AppState>) -> Action {
        if !LocationService.shared.isAuthorized {
            LocationService.shared.requestAuthorization()
        }
        return Dumb()
    }
    
    static func startListeningLocation(state: AppState, store: Store<AppState>) -> Action? {
        LocationService.shared.didChangeLocation = { location in
            store.dispatch(UpdateLocation(location: location))
        }
        return LocationService.shared.currentLocation == nil ? Dumb() : UpdateLocation(location: LocationService.shared.currentLocation!)
    }
    
    static func loadPlaces(location: CLLocation, types: [String], radius: Int = 500) -> (AppState, Store<AppState>) -> Action? {
        return { state, store in
            PlaceRepository.shared.loadPlaces(types: types, location: location.coordinate, radius: radius).then({ places in
                store.dispatch(UpdatePlaces(places: places))
            }).catch { error in
                store.dispatch(Failure(error: error))
            }
            return Loading()
        }
    }
    
    static func addToFavorites(place: Place) -> (AppState, Store<AppState>) -> Action? {
        return { state, store in
            PlaceRepository.shared.addToFavorites(place).catch { error in
                store.dispatch(Failure(error: error))
            }
            return Loading()
        }
    }
}
