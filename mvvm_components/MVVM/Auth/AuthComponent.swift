//
//  AuthComponent.swift
//  mvvm_components
//
//  Created by Andrey Chernov on 10.01.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//

import Foundation
import RxSwift

class AuthComponent: NSObject, MVVMComponent {
  @IBOutlet weak var authView: AuthView!
  let viewModel = AuthViewModel()
  func setup() {
    self.authView?.setup(with: viewModel)
  }
  
  func observeState() -> Observable<AuthViewModel.State> {
    return viewModel.observeState()
  }
}
