//
//  AuthComponent.swift
//  mvvm_components
//
//  Created by Andrey Chernov on 10.01.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AuthComponent: MVVMRxComponent {
  
  @IBOutlet weak var username: UITextField!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var repassword: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  
  let viewModel = AuthViewModel()
  
  override func setup(with initialObject: Any? = nil) {
    //Observe data
    self.observeAction(viewModel.observeData(), onNext: { data in
      //nothing to observe
    })
    
    //Bind view events to commands
    viewModel.bindActions(from:
      self.username?.rx.text.map { AuthViewModel.Action.ChangeData(AuthViewModel.DataType.Username($0)) })
    viewModel.bindActions(from:
      self.password?.rx.text.map { AuthViewModel.Action.ChangeData(AuthViewModel.DataType.Password($0)) })
    viewModel.bindActions(from:
      self.repassword?.rx.text.map { AuthViewModel.Action.ChangeData(AuthViewModel.DataType.RepeatPassword($0)) })
    
    viewModel.bindActions(from:
      self.loginButton?.rx.controlEvent(UIControlEvents.touchUpInside).map { AuthViewModel.Action.Login })
    
    //Setup
    viewModel.accept(action: .ChangeMode(.SignUp))
    
    //Observe state
    self.observeAction(viewModel.observeState, onNext: { self.stateChanged(newState: $0) })
  }
  
  private func stateChanged(newState state: AuthViewModel.State) {
    print(state)
    self.loginButton.isEnabled = state.canLogin
    switch(state) {
    case .Loading:
      //show progress?
      break
    case .Error(let error):
      //hide progress
      //show error
      break
    case .Initial:
      //show "no data"
      break
    case .Success:
      //hide progress, nothing on view level - route on another vc
      break
    case .ValidationChanged(let flags):
      
      var validationBindings: [AuthViewModel.DataValidationFlags: ValidationStateView?] = [
        .Username : self.username,
        .Password : self.password,
        .RepeatPassword: self.repassword
      ]
      
      for pair in validationBindings {
        pair.value?.changeState(toValid: !flags.contains(pair.key))
      }
      break
    }
  }
  
  //public observe
  func observeState() -> Observable<AuthViewModel.State> {
    return viewModel.observeState
  }
}

protocol ValidationStateView {
  func changeState(toValid: Bool)
}
extension UITextField: ValidationStateView {
  func changeState(toValid: Bool) {
    self.layer.borderColor = (toValid ? UIColor.gray : UIColor.red).cgColor
  }
}

