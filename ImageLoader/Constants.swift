//
//  Constants.swift
//  CoreDataNetworkLayer
//
//  Created by  Ivan Hahanov on 1/15/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation

typealias Closure<T> = (T) -> ()
typealias ResultClosure<T> = Closure<Result<T>>

enum Result<T> {
    case success(T)
    case failure(Error)
}

let GooglePlacesBaseUrl = "https://maps.googleapis.com/maps/api/place"
let GoogleAPIKey = "AIzaSyDyjNIrohQo-vQ0vsIYg_rS9f1mQwlWSqw"
