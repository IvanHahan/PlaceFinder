//
//  Reducers.swift
//  CoreDataNetworkLayer
//
//  Created by Ivan Hahanov on 2/19/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState(mapState: mapReducer(action: action, state: state?.mapState),
                    placeDetailsState: placeDetailsReducer(action: action, state: state?.placeDetailsState),
                    favoritesState: favoritesReducer(action: action, state: state?.favoritesState))
}

func mapReducer(action: Action, state: MapState?) -> MapState {
    switch action {
    case let action as UpdatePlaces:
        return .places(action.places)
    case let action as UpdateLocation:
        return .location(action.location)
    default:
        return state ?? .places([])
    }
}

func placeDetailsReducer(action: Action, state: PlaceDetailsState?) -> PlaceDetailsState {
    switch action {
    case let action as Success<Place>:
        return .saved(action.data)
    default:
        return state ?? .default
    }
}

func favoritesReducer(action: Action, state: FavoritesState?) -> FavoritesState {
    switch action {
    case let action as SetFavorites:
        return .favorites(action.places)
    default:
        return state ?? .favorites([])
    }
}

