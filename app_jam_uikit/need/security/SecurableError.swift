//
//  SecurableError.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/10/21.
//

import Foundation

enum SecurableError: Error {
  case errorOnSave(message: String = "Unable to save value to this key")
  case errorOnRetrieve(message: String = "Unable to retrieve value using the provided key.")
}
