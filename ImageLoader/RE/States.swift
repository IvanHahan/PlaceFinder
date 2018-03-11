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
}

enum MapState: StateType {
    case places([Place])
    case location(CLLocation)
    case loading
}
