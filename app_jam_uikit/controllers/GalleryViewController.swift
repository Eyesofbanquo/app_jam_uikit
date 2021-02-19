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
  
  var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
  
  // MARK: - Lifecycle -
  
  override func loadView() {
    self.view = customView.view
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var localAccessToken: String! = ""
    /// Pull access token from `Keychain`.
    do {
      if let secureAccessToken: String? = try security.retrieve(key: .accessToken), let accessToken = secureAccessToken {
        localAccessToken = accessToken
        print(accessToken)
      }
    } catch (let error) {
      print(error)
    }
    
    /// Build URL
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "api.gyazo.com"
    urlComponents.path = "/api/images"
    urlComponents.queryItems = [URLQueryItem(name: "access_token", value: localAccessToken)]
    
    /// Create url + request
    if let url = urlComponents.url, var request = try? URLRequest(url: url, method: .get), let context = store.container?.viewContext {
      print(url)
      request.cachePolicy = .returnCacheDataElseLoad
      /// Make network call
      AF.request(request).publishDecodable(type: [Source].self, decoder: JSONDecoder.decoder(withContext: context)).sink(receiveValue: { response in
        
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
