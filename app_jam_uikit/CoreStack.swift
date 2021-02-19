//
//  CoreStack.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/11/21.
//

import Combine
import CoreData
import Foundation


enum CoreStoreError: Error {
  case persistentContainerAlreadyExists
  case loadPersistentStoresError
  case genericError(message: String)
}

class CoreStore {
  
  fileprivate static var storeContainer: NSPersistentContainer?

  
  private let modelName: String
  
  /// Returns `nil` if the `CoreStore` hasn't called `prepare()`.
  var container: NSPersistentContainer? {
    return Self.storeContainer
  }
  
  init(modelName: String = "app_jam_uikit") {
    self.modelName = modelName
  }
  
  func prepare() throws {
    guard Self.storeContainer == nil else { throw CoreStoreError.persistentContainerAlreadyExists }
    
    let container = NSPersistentContainer(name: self.modelName)
    
    var errorMessage: String?
    container.loadPersistentStores {  (storeDescription, error) in
      if error != nil {
        errorMessage = error?.localizedDescription
      }
      
      container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    guard errorMessage == nil else { throw CoreStoreError.loadPersistentStoresError }
    
    Self.storeContainer = container
  }
  
  func saveContext () {
    guard let persistentContainer = container else { return }
    
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
}
