//
//  GalleryViewController.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/19/21.
//

import Foundation
import UIKit

class GalleryViewController: BaseViewController, GalleryViewDelegate {
  
  // MARK: - Lazy Properties -
  
  lazy var customView: GalleryViewControllerDelegate = {
    GalleryView()
  }()
  
  // MARK: - Lifecycle -
  
  override func loadView() {
    self.view = customView.view
  }
}
