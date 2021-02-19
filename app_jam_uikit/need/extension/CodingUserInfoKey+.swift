//
//  CodingUserInfoKey+.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/19/21.
//

import CoreData
import Foundation

extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

extension JSONDecoder {
  /// Returns a `JSONDecoder` object equipped with the given `NSManagedObjectContext`. Returns a regular `JSONDecoder` object if the provided context is nil.
  static func decoder(withContext context: NSManagedObjectContext?) -> JSONDecoder {
    guard let context = context else { return JSONDecoder() }
    
    let decoder = JSONDecoder()
    decoder.userInfo[CodingUserInfoKey.managedObjectContext] = context
    return decoder
  }
}
