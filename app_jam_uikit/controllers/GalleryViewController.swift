//
//  GalleryViewController.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/19/21.
//

import Alamofire
import Combine
import Foundation
import UIKit

class GalleryViewController: BaseViewController, GalleryViewDelegate {
  
  // MARK: - Lazy Properties -
  
  lazy var customView: GalleryViewControllerDelegate = {
    GalleryView()
  }()
  
  lazy var security: Securable = Secure()
  
  lazy var store: CoreStore = CoreStore()
  
  lazy var apiBuilder: some APIFactory = GyazoAPIFactory<GyazoAPIEndpoint>()
  
  lazy var viewModel = GalleryViewModel()
  
  // MARK: - Properties -
  
  var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
  
  let appear = PassthroughSubject<Bool, Never>()
  let selection = PassthroughSubject<String?, Never>()
  let reload = PassthroughSubject<Void, Never>()
  
  // MARK: - Lifecycle -
  
  override func loadView() {
    self.view = customView.view
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bind(to: viewModel)
    
    appear.send(true)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    reload.send(())
  }
  
  private func bind(to viewModel: GalleryViewModel) {
    cancellables.forEach { $0.cancel() }
    cancellables.removeAll()
    
    let input = GalleryViewModelInput(appear: appear.eraseToAnyPublisher(),
                                      selection: customView.selection.eraseToAnyPublisher(),
                                      reload: reload.eraseToAnyPublisher())
    let output = viewModel.transform(input: input)
    
    output.sink { [weak self] state in
      switch state {
        case .success(let items):
          if let items = items {
            self?.customView.updateSnapshot(withItems: items)
          }
        case .selectedSource(let source):
          print(source)
        default: break
      }
    }.store(in: &cancellables)
    
  }
}

extension GalleryViewController {
  
}

