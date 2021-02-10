//
//  AuthMock.swift
//  app_jam_uikitTests
//
//  Created by Markim Shaw on 2/10/21.
//

import Combine
import Foundation
import UIKit
import XCTest

@testable import app_jam_uikit

final class AuthMock: Authenticatable, Mockable {
  static var MOCK_ACCESS_TOKEN = "accessToken"
  
  var type: AuthenticatorType
  var exp: XCTestExpectation?
  
  init(for type: AuthenticatorType) {
    
    self.type = type
  }
  
  func authorize(in controller: UIViewController?) -> Future<String?, Never> {
    return Future<String?, Never> { seal in
      seal(.success(Self.MOCK_ACCESS_TOKEN))
    }
  }
  
  func handleRedirect(_ url: URL?) {
    exp?.fulfill()
  }
  
  
}
