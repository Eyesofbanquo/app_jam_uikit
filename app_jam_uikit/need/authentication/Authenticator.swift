//
//  Authenticator.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/8/21.
//

import Combine
import Foundation
import OAuth2
import UIKit

enum AuthenticatorTypeError: Error {
  case grantError(message: String)
}

@objc enum AuthenticatorType: Int {
  case gyazo
  
  func grant() throws -> OAuth2CodeGrant? {
    switch self {
      case .gyazo:
        do {
          let oauth2Grant = OAuth2CodeGrant(settings: [
            "client_id": try Configuration.value(for: .apiClientId),
            "client_secret": try Configuration.value(for: .apiClientSecret),
            "authorize_uri": "https://api.gyazo.com/oauth/authorize",
            "token_uri": "https://api.gyazo.com/oauth/token",
            "redirect_uris": [try Configuration.value(for: .apiCallbackUrl) + "//callback"],
            "secret_in_body": true,
            "keychain": false
          ] as OAuth2JSON)
          
          return oauth2Grant
        } catch (let error) {
          throw AuthenticatorTypeError.grantError(message: error.localizedDescription)
        }
    }
  }
}

final class Authenticator: Authenticatable {
  
  var grant: OAuth2CodeGrant?
  var type: AuthenticatorType
  
  init(for type: AuthenticatorType) {
    self.type = type
    self.grant = try? type.grant()
  }
  
  func authorize(in controller: UIViewController?) -> Future<String?, Never> {
    guard let controller = controller, let grant = self.grant else {
      return Future<String?, Never> { seal in
        seal(.success(nil))
      }
    }
    
    grant.authConfig.authorizeEmbedded = true
    grant.authConfig.authorizeContext = controller
        
    return Future<String?, Never> { seal in
      
      DispatchQueue.main.async {
        grant.authorize() { params, error in
          if let params = params, let accessToken = params["access_token"] as? String {
            seal(.success(accessToken))
          }
        }
      }
    }
  }
  
  func handleRedirect(_ url: URL?) {
    guard let url = url else { return }
    self.grant?.handleRedirectURL(url)
  }
}
