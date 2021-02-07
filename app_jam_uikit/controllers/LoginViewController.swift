//
//  LoginViewController.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/6/21.
//

import Foundation
import UIKit

final class LoginViewController: BaseViewController {
  lazy var viewDelegate: LoginViewControllerDelegate? = {
    LoginView()
  }()
  
  init(viewDelegate: LoginViewControllerDelegate? = LoginView()) {
    super.init()
    
    self.viewDelegate = viewDelegate
    self.viewDelegate?.delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    self.view = viewDelegate?.view
  }
}

extension LoginViewController: LoginViewDelegate {
  func loginView(_ loginView: LoginViewControllerDelegate, didTapSignupButton: UIButton) {
    print("tapped")
  }
}
