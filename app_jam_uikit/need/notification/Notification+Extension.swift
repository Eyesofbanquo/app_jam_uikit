//
//  Notification+Extension.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/8/21.
//

import Foundation

extension Notification.Name {
  static var returnFromAuth: Notification.Name = Notification.Name("returnFromAuth")
  static var loggedOut: Notification.Name = Notification.Name("loggedOut")
  static var loggedIn: Notification.Name = Notification.Name("loggedIn")
}
