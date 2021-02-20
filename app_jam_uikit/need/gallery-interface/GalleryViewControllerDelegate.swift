//
//  GalleryViewControllerDelegate.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/19/21.
//

import Combine
import Foundation
import UIKit

protocol GalleryViewControllerDelegate {
  
  var view: UIView { get }
  
  var selection: PassthroughSubject<String?, Never> { get set }
}
