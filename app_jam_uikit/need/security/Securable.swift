//
//  Securable.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/10/21.
//

import Foundation

protocol Securable {
  @discardableResult
  func save(key: SecurityKey, value: Any?, in: SecureAccessLevel) throws -> Bool
  func retrieve<T>(key: SecurityKey, from: SecureAccessLevel) throws -> T?
}
