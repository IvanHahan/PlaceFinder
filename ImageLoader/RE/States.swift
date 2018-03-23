//
//  States.swift
//  CoreDataNetworkLayer
//
//  Created by Ivan Hahanov on 2/19/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import ReSwift
import CoreLocation

struct AppState: StateType {
    let mapState: MapState
    let placeDetailsState: PlaceDetailsState
    let favoritesState: FavoritesState
}

enum MapState: StateType {
    case places([Place])
    case location(CLLocation)
    case loading
}

enum PlaceDetailsState: StateType {
    case `default`, saved(Place)
}

enum FavoritesState: StateType {
    case `default`, favorites([Place]), remove(Place)
}
