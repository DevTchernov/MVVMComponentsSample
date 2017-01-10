//
//  AuthView.swift
//  mvvm_components
//
//  Created by Andrey Chernov on 10.01.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//

import Foundation
import RxCocoa

class AuthView: UIRxView {
  @IBOutlet weak var username: UITextField!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  
 	func setup(with viewModel: AuthViewModel) {
    //subscription
    self.observeAction(viewModel.observeData(), onNext: { data in
      switch(data) {
      case .Username(let text):
        self.username?.text = text
        break
      case .Password(let text):
        self.password?.text = text
        break
      }
    })
    
    //input binding
    //username
    self.bindControlProperty(
      controlProperty: self.username?.rx.text,
      withFabric: { .ChangeData(AuthViewModel.DataType.Username($0 ?? "")) },
      toAction: viewModel.accept)
    //password
    self.bindControlProperty(
      controlProperty: self.password?.rx.text,
      withFabric: { .ChangeData(AuthViewModel.DataType.Password($0 ?? "")) },
      toAction: viewModel.accept)
    
    //Login button
    self.bindControlEvent(
      controlEvent: self.loginButton?.rx.controlEvent(UIControlEvents.touchUpInside),
      withFabric: { AuthViewModel.Action.SignIn },
      toAction: viewModel.accept)
  }
}
