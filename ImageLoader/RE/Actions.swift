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
import UserNotifications

struct Loading: Action {}
struct Failure: Action { let error: Error }
struct Success<T>: Action { let data: T }
struct Dumb: Action {}
struct Default: Action {}

struct UpdateLocation: Action { let location: CLLocation }

struct UpdatePlaces: Action { let places: [Place] }

func requestLocationAuthorization(state: AppState, store: Store<AppState>) -> Action {
    if !LocationService.shared.isAuthorized {
        LocationService.shared.requestAuthorization()
    }
    return Dumb()
}

func startListeningLocation(state: AppState, store: Store<AppState>) -> Action? {
    LocationService.shared.startObservingLocation { location in
        store.dispatch(UpdateLocation(location: location))
    }
    return LocationService.shared.currentLocation == nil ? Dumb() : UpdateLocation(location: LocationService.shared.currentLocation!)
}

func loadPlaces(location: CLLocation, types: [String], radius: Int = 500) -> (AppState, Store<AppState>) -> Action? {
    return { state, store in
        PlaceRepository.shared.loadPlaces(types: types, location: location.coordinate, radius: radius).then({ places in
            store.dispatch(UpdatePlaces(places: places))
        }).catch { error in
            store.dispatch(Failure(error: error))
        }
        return Loading()
    }
}


func addToFavorites(place: Place) -> (AppState, Store<AppState>) -> Action? {
    return { state, store in
        PlaceRepository.shared.addToFavorites(place).then {
            store.dispatch(Success(data: place))
            }.catch { error in
            store.dispatch(Failure(error: error))
        }
        
        let region = CLCircularRegion(center: place.coordinate, radius: 1000, identifier: place.name)
        NotificationService.scheduleLocationNotification(title: "Favorite place nearby", body: place.name, region: region)
        
        return Loading()
    }
}

struct SetFavorites: Action { let places: [Place] }

func loadFavorites(state: AppState, store: Store<AppState>) -> Action? {
    PlaceRepository.shared.loadFavorites().then { places in
        store.dispatch(SetFavorites(places: places))
    }
    return Loading()
}

