//
//  Person+CoreDataProperties.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/11/21.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Float

}

extension Person : Identifiable {

}
