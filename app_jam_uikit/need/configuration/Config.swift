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
  
  static func value<T>(for key: ConfigKey) throws -> T where T: LosslessStringConvertible {
    guard let object = Bundle.main.object(forInfoDictionaryKey: key.rawValue) else {
      throw Error.missingKey
    }
    
    switch object {
      case let value as T:
        return value
      case let string as String:
        guard let value = T(string) else { fallthrough }
        return value
      default:
        throw Error.invalidValue
    }
  }
}
