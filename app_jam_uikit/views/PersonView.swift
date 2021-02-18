//
//  PersonView.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/13/21.
//

import Combine
import CoreData
import Foundation
import UIKit

protocol BaseViewModel: AnyObject {
  associatedtype T: NSManagedObject & Fetchable
  var store: CoreStore { get set }
  var request: NSFetchRequest<T.T> { get set }
  var fetchedResultsController: NSFetchedResultsController<T>! { get set }
  func performFetch()
}

extension BaseViewModel where Self: NSObject & NSFetchedResultsControllerDelegate {
  
  func prepare() {
    guard let container = store.container else { return }
    
    if let typedRequest = request as? NSFetchRequest<T> {
      fetchedResultsController = NSFetchedResultsController<T>(fetchRequest: typedRequest, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
      fetchedResultsController.delegate = self
    }
  }
  
  func performFetch() {
    do {
      try fetchedResultsController.performFetch()
    } catch {
      print("Error")
    }
  }
  
}

class PersonViewModel<T: NSManagedObject & Fetchable>: NSObject, NSFetchedResultsControllerDelegate, BaseViewModel {
    
  let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
  var request = T.createFetchRequest()
  var fetchedResultsController: NSFetchedResultsController<T>!
  lazy var store: CoreStore = CoreStore()
  lazy var notifyChanges: PassthroughSubject<Bool, Never> = PassthroughSubject<Bool, Never>()
  
  override init() {
    super.init()
    
    request.sortDescriptors = [sortDescriptor]
    
    prepare()
  }
  
  func add(_ person: Person) {
    guard let container = store.container else { return }
    
    let newObject = Person()
    newObject.age = 28
    newObject.name = "Markim"
    
    _ = Person.createNewManagedObject(fromPerson: newObject, in: container.viewContext)
    
    store.saveContext()
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    // This will be used later on
    notifyChanges.send(true)
  }
}

class PersonTableViewCell: UITableViewCell {
  static var reuseIdentifier: String = "PersonTableViewCell"
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

enum PersonTableViewSection: CaseIterable {
  case name
}

final class PersonView: UIView {

  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: PersonTableViewCell.reuseIdentifier)
    
    return tableView
  }()
  
  lazy var diffableDataSource = UITableViewDiffableDataSource<PersonTableViewSection, Person>(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in
    let cell = tableView.dequeueReusableCell(withIdentifier: PersonTableViewCell.reuseIdentifier, for: indexPath)
    cell.textLabel?.text = item.name
    return cell
  }
  
  lazy var viewModel: some BaseViewModel = PersonViewModel<Person>()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    
    addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.leading.equalTo(self)
      make.trailing.equalTo(self)
      make.bottom.equalTo(self)
      make.top.equalTo(self)
    }
    
    viewModel.performFetch()
  }
  
  override func layoutSubviews() {
    updateSnapshot()

  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func updateSnapshot() {
    if let fetchedObjects = viewModel.fetchedResultsController.fetchedObjects as? [Person] {
      var diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<PersonTableViewSection, Person>()
      diffableDataSourceSnapshot.appendSections(PersonTableViewSection.allCases)
      diffableDataSourceSnapshot.appendItems(fetchedObjects, toSection: .name)
      diffableDataSource.apply(diffableDataSourceSnapshot)
    }
    
  }
}
