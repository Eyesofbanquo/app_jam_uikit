//
//  SecurityKey.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/10/21.
//

import Foundation

enum SecurityKey: String {
  case accessToken = "access_token"
  
  /// This is where the key *should* be stored.
  var preferredDestination: SecureAccessLevel {
    switch self {
      case .accessToken: return .keychain
    }
  }
}
