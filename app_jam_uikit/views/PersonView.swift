//
//  PersonView.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/13/21.
//

import CoreData
import Foundation
import UIKit

class PersonViewModel: NSObject {
  let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
  let request = Person.createFetchRequest()
  var fetchedResultsController: NSFetchedResultsController<Person>!
  lazy var store: CoreStore = CoreStore()
  
  override init() {
    super.init()
    
    request.sortDescriptors = [sortDescriptor]
    
    guard let container = store.container else { return }
    
    fetchedResultsController = NSFetchedResultsController<Person>(fetchRequest: request, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    fetchedResultsController.delegate = self
  }
  
  func performFetch() {
    do {
      try fetchedResultsController.performFetch()
    } catch {
      print("Error")
    }
  }
  
  
}

extension PersonViewModel: NSFetchedResultsControllerDelegate {
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    // This will be used later on
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
  
  lazy var viewModel = PersonViewModel()
  
  
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
    var diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<PersonTableViewSection, Person>()
    diffableDataSourceSnapshot.appendSections(PersonTableViewSection.allCases)
    diffableDataSourceSnapshot.appendItems(viewModel.fetchedResultsController.fetchedObjects ?? [], toSection: .name)
    diffableDataSource.apply(diffableDataSourceSnapshot)
  }
}
