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
  
  // MARK: - Properties -
  
  var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
  
  // MARK: - Lifecycle -
  
  override func loadView() {
    self.view = customView.view
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if var request = apiBuilder.createUrl(for: GyazoAPIEndpoint.images), let context = store.container?.viewContext {
      request.cachePolicy = .returnCacheDataElseLoad
      /// Make network call
      AF.request(request).publishDecodable(type: [Source].self, decoder: JSONDecoder.decoder(withContext: context)).sink(receiveValue: { [weak self] response in
        /// Retrieve data
        let result = try? response.result.get()
        print(result)
        /// Optional: Save data into core data
        
      }).store(in: &cancellables)
    }
    
  }
}

extension GalleryViewController {
  
}
