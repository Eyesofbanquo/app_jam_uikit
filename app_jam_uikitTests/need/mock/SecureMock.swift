//
//  SecureMock.swift
//  app_jam_uikitTests
//
//  Created by Markim Shaw on 2/10/21.
//

import Combine
import Foundation
import UIKit
import XCTest

@testable import app_jam_uikit

final class SecureMock: Securable, Mockable {
  static var MOCK_RETRIEVE = "retrieved"
  
  var exp: XCTestExpectation?
  

  func save(key: SecurityKey, value: Any?, in: SecureAccessLevel) throws -> Bool {
    return true
  }
  
  func retrieve<T>(key: SecurityKey, from: SecureAccessLevel) throws -> T? {
    return Self.MOCK_RETRIEVE as? T
  }
}
