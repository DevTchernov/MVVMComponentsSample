//
//  AuthComponent.swift
//  mvvm_components
//
//  Created by Andrey Chernov on 10.01.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//

import Foundation
import RxSwift

class AuthComponent: MVVMRxComponent {
  
  @IBOutlet weak var username: UITextField!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  
  
  let viewModel = AuthViewModel()
  
  override func setup() {
    
    //Observe data
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
    
    //Bind view events to commands
    self.bindControlProperty(
      controlProperty: self.username?.rx.text,
      withFabric: { .ChangeData(AuthViewModel.DataType.Username($0)) },
      toAction: viewModel.accept)
    self.bindControlProperty(
      controlProperty: self.password?.rx.text,
      withFabric: { .ChangeData(AuthViewModel.DataType.Password($0)) },
      toAction: viewModel.accept)
    self.bindControlEvent(
      controlEvent: self.loginButton?.rx.controlEvent(UIControlEvents.touchUpInside),
      withFabric: { .SignIn },
      toAction: viewModel.accept)
    
    //Observe state
    self.observeAction(viewModel.observeState(), onNext: {
      state -> Void in
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
        self.username?.textColor = flags.contains(.Username) ? UIColor.black : UIColor.red
        self.password?.textColor = flags.contains(.Password) ? UIColor.black : UIColor.red
        break
      }
    })
  }
  
  //public observe
  func observeState() -> Observable<AuthViewModel.State> {
    return viewModel.observeState()
  }
}
