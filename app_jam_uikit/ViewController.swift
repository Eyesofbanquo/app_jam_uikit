//
//  ViewController.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/6/21.
//

import UIKit

class ViewController: BaseViewController {
  
  override init() {
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.backgroundColor = .green
    if let url = try? Configuration.value(for: .apiClientId) {
      print(url, "yikes")
    }
  }
}

