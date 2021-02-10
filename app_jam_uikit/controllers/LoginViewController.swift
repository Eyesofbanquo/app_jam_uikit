//
//  LoginViewController.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/6/21.
//

import Combine
import Foundation
import UIKit

final class LoginViewController: BaseViewController {
  lazy var viewDelegate: LoginViewControllerDelegate? = {
    LoginView()
  }()
  
  var authenticator: Authenticatable
  var security: Securable
  lazy var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
  
  init(viewDelegate: LoginViewControllerDelegate? = LoginView(),
       authenticator: Authenticatable = Authenticator(for: .gyazo),
       security: Securable = Secure()) {
    self.authenticator = authenticator
    self.security = security
    
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupCallbackFromOAuth()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  private func setupCallbackFromOAuth() {
    NotificationCenter.default.publisher(for: .returnFromAuth).sink { [weak self] notification in
      guard let url = notification.userInfo?["url"] as? URL else { return } // needs error handling
      
      self?.authenticator.handleRedirect(url)
    }.store(in: &cancellables)
  }
}

extension LoginViewController: LoginViewDelegate {
  func loginView(_ loginView: LoginViewControllerDelegate, didTapSignupButton: UIButton) {
    print("tapped signup")
  }
  
  func loginView(_ loginView: LoginViewControllerDelegate, didTapLoginButton: UIButton) {
    authenticator.authorize(in: self).sink { [weak self] accessToken in
      do {
        try self?.security.save(key: .accessToken, value: accessToken)
      } catch let error {
        print(error)
      }
    }.store(in: &cancellables)
  }
}
