//
//  MainViewController.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/11/21.
//

import Foundation
import UIKit

class MainViewController: UITabBarController {
  
  lazy var viewController: ViewController = ViewController()
  lazy var loginController: LoginViewController = LoginViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .systemBackground
    
    viewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "photo"), selectedImage: UIImage(systemName: "photo.fill"))
    loginController.tabBarItem = UITabBarItem(title: "Login", image: UIImage(systemName: "livephoto"), selectedImage: UIImage(systemName: "livephoto.slash"))
    
    let controllerList = [viewController, loginController]
    
    self.viewControllers = controllerList
    
  }
}
