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

class PlaceRepository {
    private let context: NSManagedObjectContext
    private let sessionManager: SessionManager
    
    init(sessionManager: SessionManager,
         context: NSManagedObjectContext) {
        self.sessionManager = sessionManager
        self.context = context
    }
}
