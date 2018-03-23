//
//  PlaceMO+CoreDataProperties.swift
//  
//
//  Created by Ivan Hahanov on 3/21/18.
//
//

import Foundation
import CoreData


extension PlaceMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlaceMO> {
        return NSFetchRequest<PlaceMO>(entityName: "PlaceMO")
    }

    @NSManaged public var address: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var photoRef: String?
    @NSManaged public var id: String?
    @NSManaged public var icon: URL?

}
