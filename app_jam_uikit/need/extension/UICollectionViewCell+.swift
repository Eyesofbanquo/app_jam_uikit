//
//  UICollectionViewCell+.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/19/21.
//

import Foundation
import UIKit

extension UICollectionViewCell {
  static var reuseIdentifier: String { String(describing: Self.self) }
}
