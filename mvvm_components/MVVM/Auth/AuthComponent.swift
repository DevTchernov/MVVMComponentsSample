//
//  AuthComponent.swift
//  mvvm_components
//
//  Created by Andrey Chernov on 10.01.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//

import Foundation
import RxSwift

class AuthComponent: MVVMComponent {
  
  @IBOutlet weak var username: UITextField!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  
  @IBOutlet weak var authView: AuthView!
  let viewModel = AuthViewModel()
  override func setup() {
    
    self.authView?.setup(with: viewModel)
    
  }
  
  func observeState() -> Observable<AuthViewModel.State> {
    return viewModel.observeState()
  }
}
