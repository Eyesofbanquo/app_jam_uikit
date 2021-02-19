//
//  GyazoAPIBuilder.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/19/21.
//

import Foundation

protocol APIBuilder {
  func buildUrl(for endpoint: Endpoint) -> URLRequest?
}

protocol Endpoint {
  var rawValue: String { get }
}

enum GyazoAPIEndpoint: String, Endpoint {
  case images
}

final class GyazoAPIFactory {
  
  func createUrl(for endpoint: GyazoAPIEndpoint) -> URLRequest? {
    let security = Secure()
    
    var localAccessToken: String! = ""
    /// Pull access token from `Keychain`.
    do {
      if let secureAccessToken: String? = try security.retrieve(key: .accessToken), let accessToken = secureAccessToken {
        localAccessToken = accessToken
        
      }
    } catch {
      return nil
    }
    
    /// Build URL
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "api.gyazo.com"
    urlComponents.path = "/api/\(endpoint.rawValue)"
    urlComponents.queryItems = [URLQueryItem(name: "access_token", value: localAccessToken)]
    
    guard let url = urlComponents.url, let request = try? URLRequest(url: url, method: .get) else {
      return nil
    }
    
    return request
    
  }
}
