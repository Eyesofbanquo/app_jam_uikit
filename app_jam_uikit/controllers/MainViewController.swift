//
//  MainViewController.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/11/21.
//

import Foundation
import UIKit

class NavigationController : UINavigationController {
  
  override var preferredStatusBarStyle : UIStatusBarStyle {
    
    if let topVC = viewControllers.last {
      //return the status property of each VC, look at step 2
      return topVC.preferredStatusBarStyle
    }
    
    return .default
  }
}
  
  class MainViewController: UITabBarController {
    
    lazy var viewController: ViewController = ViewController()
    lazy var loginController: LoginViewController = LoginViewController()
    
    override func viewDidLoad() {
      super.viewDidLoad()
      
      self.view.backgroundColor = .systemBackground
      
      viewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "photo"), selectedImage: UIImage(systemName: "photo.fill"))
      
      
      loginController.tabBarItem = UITabBarItem(title: "Login", image: UIImage(systemName: "livephoto"), selectedImage: UIImage(systemName: "livephoto.slash"))
      
      let controllerList = [viewController, loginController]
      
      self.viewControllers = controllerList.map { NavigationController(rootViewController: $0) }
      
      viewController.navigationController?.navigationBar.prefersLargeTitles = true
      viewController.navigationController?.navigationBar.standardAppearance = viewControllerNavigationAppearance()
      viewController.navigationController?.navigationBar.scrollEdgeAppearance = viewControllerNavigationAppearance()
      
    }
    
    fileprivate func viewControllerNavigationAppearance() -> UINavigationBarAppearance {
      let coloredAppearance = UINavigationBarAppearance()
      coloredAppearance.configureWithTransparentBackground()
      coloredAppearance.backgroundColor = .systemPink
      coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
      coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
      
      return coloredAppearance
    }
  }
