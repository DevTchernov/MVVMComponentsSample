//
//  ViewModel.swift
//  mvvm_components
//
//  Created by Andrey Chernov on 10.01.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AuthViewModel: RxViewModel {
  //MARK: - Enums
  enum DataType {
    case Username(String)
    case Password(String)
  }
  enum State {
    case Initial
    case InvalidInput(DataType)
    case ValidInput(DataType)
    case Error(Error)
    case Success
    case Loading
  }
  
  enum Action {
    case ChangeData(DataType)
    case SignIn
    case SignUp
  }
  
  //MARK: - Variables
  private var currentUsername = Variable<String>("")
  private var currentPassword = Variable<String>("")
  private var currentState = Variable<State>(.Initial)
  
  //MARK: - Observables
  func observeData() -> Observable<DataType> {
    return Observable.of(
      currentUsername.asObservable().map{ DataType.Username($0) },
      currentPassword.asObservable().map{ DataType.Password($0) }).merge()
  }
  
  func observeState() -> Observable<State> {
    return self.currentState.asObservable()
  }
  
  //MARK: - Commands
  func accept(action: Action) {
    switch(action) {
    case .SignIn, .SignUp:
      //run services methods
      self.currentState.value = .Loading
      //send commands to auth service
      
      break
    case .ChangeData(let dataType):
      switch (dataType) {
      case .Password(let text):
        self.currentPassword.value = text
        break
      case .Username(let text):
        self.currentUsername.value = text
        break
      }
      break
    }
  }
}
