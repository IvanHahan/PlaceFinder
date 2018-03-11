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
    return AppState(mapState: mapReducer(action: action, state: state?.mapState))
}

func mapReducer(action: Action, state: MapState?) -> MapState {
    return state ?? .places([])
}

