//
//  NetworkBuilder.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/19/21.
//

import Alamofire
import Combine
import Foundation

class NetworkBuilder {
  var decodableType: Decodable.Type?
  var request: URLRequest?
  var decoder: JSONDecoder?
  
  init(request: URLRequest? = nil) {
    self.request = request
  }
  
  func setDecodableType<T: Decodable>(_ type: T.Type) -> NetworkBuilder {
    self.decodableType = type
    return self
  }
  
  func setDecoder(_ decoder: JSONDecoder) -> NetworkBuilder {
    self.decoder = decoder
    return self
  }
  
  func setCachePolicy(_ policy: URLRequest.CachePolicy) -> NetworkBuilder {
    self.request?.cachePolicy = policy
    return self
  }
  
  func build<T: Decodable>(forType type: T.Type, saveTo store: CoreStore) -> AnyCancellable? {
    guard let request = request, let decoder = decoder else {
      return nil
    }
    let networkCall = AF.request(request).publishDecodable(type: type.self, decoder: decoder).sink { response in
      /// Retrieve data
      let _ = try? response.result.get()
      
      store.saveContext()
      /// Optional: Save data into core data
    }
    
    return networkCall
  }
  
  
  func build<T: Decodable>(forType type: T.Type) -> AnyPublisher<DataResponse<T, AFError>, Never>? {
    guard let request = request, let decoder = decoder else {
      return nil
    }
    return AF.request(request).publishDecodable(type: type.self, decoder: decoder).eraseToAnyPublisher()
  }
  
}
