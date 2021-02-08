//
//  BaseViewController.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/6/21.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .systemBackground
  }
}
