//
//  GalleryViewModel.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/20/21.
//

import Alamofire
import Combine
import CoreData
import Foundation
import UIKit

typealias GalleryViewModelOutput = AnyPublisher<GalleryViewControllerState, Never>

protocol GalleryViewControllerActionable {
  //  func selectSource(withId sourceId: String) -> AnyPublisher<Result<Source, Never>, Never>
  func loadSources()
}

enum GalleryViewControllerState {
  case idle
  case loading
  case success([Source]?)
  case selectedSource(Source)
  case noResults
  case failure(Error)
}

struct GalleryViewModelInput {
  /// Called when the view appears
  let appear: AnyPublisher<Bool, Never>
  let selection: AnyPublisher<String?, Never>
  let reload: AnyPublisher<Void, Never>
}

final class GalleryViewModel {
  
  // MARK: - Lazy Properties -
  lazy var store = CoreStore()
  lazy var sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "imageId", ascending: false)
  lazy var fetchRequest: NSFetchRequest<Source> = Source.fetchRequest()
  lazy var apiBuilder: some APIFactory = GyazoAPIFactory<GyazoAPIEndpoint>()
  
  // MARK - Properties -
  private var cancellables: [AnyCancellable] = []
  
  private var fetchedController: NSFetchedResultsController<Source>!
  
  
  init() {
    self.fetchRequest.sortDescriptors = [sortDescriptor]
    guard let context = self.store.container?.viewContext else { return }
    
    self.fetchedController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
  }
  
  func transform(input: GalleryViewModelInput) -> GalleryViewModelOutput {
    /// Clear out all cancellables
    
    cancellables.forEach { $0.cancel() }
    cancellables.removeAll()
    
    let didSelect = input.selection
      .map { [weak self] id in self?.fetchedController.fetchedObjects?.first(where: {$0.imageId == id})}
      .compactMap {  $0 }
      .map { value -> GalleryViewControllerState in .selectedSource(value)}
      .eraseToAnyPublisher()
    
    let didAppear = input.appear.filter { $0 == true }
    let b = didAppear
      .compactMap { [weak self] _ -> AnyPublisher<DataResponse<[Source], AFError>, Never>? in
        /// This logic could be tied to Actionables
        if let request = self?.apiBuilder.createUrl(for: GyazoAPIEndpoint.images), let context = self?.store.container?.viewContext {
          return NetworkBuilder(request: request)
            .setCachePolicy(.returnCacheDataElseLoad)
            .setDecoder(JSONDecoder.decoder(withContext: context))
            .build(forType: [Source].self)?.eraseToAnyPublisher()
        }
        return nil
      }
      .flatMap { $0 }
      .map { val -> GalleryViewControllerState in
        if let values = try? val.result.get() {
          return .success(values)
        } else {
          return .noResults
        }
      }
      .eraseToAnyPublisher()
    
    let initialState: GalleryViewModelOutput = Just(.idle).eraseToAnyPublisher()
    
    return Publishers.MergeMany(initialState, b, didSelect).eraseToAnyPublisher()
  }
}
