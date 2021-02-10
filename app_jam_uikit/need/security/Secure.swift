//
//  Secure.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/8/21.
//

import Foundation
import KeychainAccess

fileprivate let defaults = UserDefaults.standard
fileprivate var keychainService: String = "com.markimcodes.app-jam-uikit"
fileprivate var keychain: Keychain = {
  let keychain = Keychain(service: keychainService, accessGroup: "2W3P634BS8.com.markimcodes.app-jam-uikit")
  return keychain
}()

class Secure: Securable {
  @discardableResult
  func save(key: SecurityKey, value: Any?) throws -> Bool {
    
    switch key.preferredDestination {
      case .defaults:
        defaults.setValue(value, forKey: key.rawValue)
        return true
      case .keychain:
        do {
          if let stringValue = value as? String {
            try keychain.set(stringValue, key: key.rawValue)
            return true
          }
        } catch (let error) {
          throw SecurableError.errorOnSave(message: error.localizedDescription)
      }
    }
    
    return false
  }
  
  func retrieve<T: Any>(key: SecurityKey) throws -> T? {
    
    switch key.preferredDestination {
      case .defaults:
        return defaults.value(forKey: key.rawValue) as? T
      case .keychain:
        do {
          return try keychain.get(key.rawValue) as? T
        } catch (let error) {
          throw SecurableError.errorOnRetrieve(message: error.localizedDescription)
        }
    }
  }
}
