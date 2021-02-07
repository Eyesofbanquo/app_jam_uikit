//
//  LoginView.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/7/21.
//

import Foundation
import SnapKit
import UIKit

protocol LoginViewDelegate: AnyObject {
  func loginView(_ loginView: LoginViewControllerDelegate, didTapSignupButton: UIButton)
}

protocol LoginViewControllerDelegate: AnyObject {
  var view: UIView { get }
  var delegate: LoginViewDelegate? { get set }
  var signupButton: UIButton { get }
  var loginButton: UIButton { get }
}

class LoginView: UIView, LoginViewControllerDelegate {
  var view: UIView {
    return self
  }
  
  lazy var signupButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Sign Up", for: .normal)
    button.setTitleColor(.label, for: .normal)
    button.backgroundColor = .systemPink
//    button.layer.cornerRadius = 8.0
    button.clipsToBounds = true
    return button
  }()
  
  lazy var loginButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Login", for: .normal)
    button.setTitleColor(.label, for: .normal)
    button.backgroundColor = .systemGreen
//    button.layer.cornerRadius = 8.0
    button.clipsToBounds = true
    return button
  }()
  
  lazy var buttonStack: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 8.0
    
    return stackView
  }()
  
  weak var delegate: LoginViewDelegate?
  
  
  init() {    
    super.init(frame: .zero)
    
    backgroundColor = .systemBackground
    
    buttonStack.addArrangedSubview(loginButton)
    buttonStack.addArrangedSubview(signupButton)
    self.addSubview(buttonStack)
    
    buttonStack.snp.makeConstraints { make in
      make.leading.equalTo(layoutMarginsGuide.snp.leading)
      make.trailing.equalTo(layoutMarginsGuide.snp.trailing)
      make.bottom.equalTo(layoutMarginsGuide.snp.bottom).offset(-8.0)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
