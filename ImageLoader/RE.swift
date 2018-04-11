//
//  Reducers.swift
//  CoreDataNetworkLayer
//
//  Created by Ivan Hahanov on 2/19/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import ReSwift

struct AppState: StateType {
    let mapState: MapController.State
    let placeDetailsState: PlaceDetailsController.State
    let favoritesState: FavoritesController.State
}

func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState(mapState: MapController.reducer(action: action, state: state?.mapState),
                    placeDetailsState: PlaceDetailsController.reducer(action: action, state: state?.placeDetailsState),
                    favoritesState: FavoritesController.reducer(action: action, state: state?.favoritesState))
}


struct Loading: Action {}
struct Failure: Action { let error: Error }
struct Success<T>: Action { let data: T }
struct Dumb: Action {}
