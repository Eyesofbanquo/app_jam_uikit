//
//  Mockable.swift
//  app_jam_uikitTests
//
//  Created by Markim Shaw on 2/10/21.
//

import Foundation
import XCTest

protocol Mockable {
  var exp: XCTestExpectation? { get set }
}
