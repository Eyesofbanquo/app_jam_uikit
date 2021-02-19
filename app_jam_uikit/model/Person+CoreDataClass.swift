//
//  Person+CoreDataClass.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/11/21.
//
//

import Foundation
import Combine
import CoreData

protocol Fetchable {
  associatedtype T: NSFetchRequestResult
  static func createFetchRequest() -> NSFetchRequest<T>
}

@objc(Person)
public class Person: NSManagedObject, Fetchable {
    
  @nonobjc public class func createFetchRequest() -> NSFetchRequest<Person> {
    return NSFetchRequest<Person>(entityName: "Person")
  }

  @objc class func createNewManagedObject(fromPerson person: Person, in context: NSManagedObjectContext) -> NSManagedObject? {
    let description = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context)
    description.setValue(person.name, forKey: "name")
    description.setValue(person.age, forKey: "age")
    return description
  }
}
