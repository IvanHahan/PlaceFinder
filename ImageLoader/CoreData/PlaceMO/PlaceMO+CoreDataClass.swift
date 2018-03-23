//
//  PlaceMO+CoreDataClass.swift
//  
//
//  Created by Ivan Hahanov on 3/21/18.
//
//

import Foundation
import CoreData

@objc(PlaceMO)
final public class PlaceMO: NSManagedObject, Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [
            NSSortDescriptor(key: #keyPath(id), ascending: true)
        ]
    }
}
