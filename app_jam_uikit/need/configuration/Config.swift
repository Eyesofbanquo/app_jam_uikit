//
//  Config.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/6/21.
//

import Foundation

enum Configuration {
  enum Error: Swift.Error {
    case missingKey, invalidValue
  }
  
  static func value(for key: ConfigKey) throws -> String {
    guard let object = Bundle.main.object(forInfoDictionaryKey: key.rawValue) else {
      throw Error.missingKey
    }
    
    switch object {
      case let string as String:
        return string
      default:
        throw Error.invalidValue
    }
  }
}
