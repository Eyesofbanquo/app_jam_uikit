//
//  PersonViewController.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/13/21.
//

import CoreData
import Foundation
import UIKit

final class PersonViewController: BaseViewController {
  
  private var customView: PersonView {
    PersonView()
  }
  
  override func loadView() {
    self.view = customView
  }
  
  override init() {
    super.init()
    
    let store = CoreStore()
    
    if let context = store.container?.viewContext {
      let fetchRequest = Person.createFetchRequest()
      let objects = try? context.fetch(fetchRequest)
      if objects?.first(where: {$0.name == "Markim"}) == nil {
        var entityDescription = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context)
        entityDescription.setValue("Markim", forKey: "name")
        entityDescription.setValue(28, forKey: "age")
        
        store.saveContext()
      }
    }
    
   
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
