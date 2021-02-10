//
//  Authenticatable.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/8/21.
//

import Combine
import Foundation
import UIKit

protocol Authenticatable: AnyObject {
  var type: AuthenticatorType { get }
  
  init(for type: AuthenticatorType)
  
  /// Authorize function that returns an `access token`.
  /// - Parameter controller: The controller that called the `authorize` function.
  func authorize(in controller: UIViewController?) -> Future<String?, Never>
  
  func handleRedirect(_ url: URL?)
}
