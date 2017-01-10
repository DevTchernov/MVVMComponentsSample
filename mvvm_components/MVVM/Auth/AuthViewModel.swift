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
    case Username(String?)
    case Password(String?)
  }
  
  struct DataValidationFlags: OptionSet {
    let rawValue: Int
    static let NonValid = DataValidationFlags(rawValue: 0)
    static let Username = DataValidationFlags(rawValue: 1)
    static let Password = DataValidationFlags(rawValue: 2)
    static let Valid: DataValidationFlags = [.Username, .Password]
  }
  
  enum State {
    case Initial
    case ValidationChanged(DataValidationFlags)
    case Error(Error)
    case Success
    case Loading
    
    var canLogin:Bool {
      get {
        switch(self) {
        case .ValidationChanged(let flags):
          return flags == .Valid
        default:
          return false
        }
      }
    }
  }
  
  enum Action {
    case ChangeData(DataType)
    case SignIn
    case SignUp
  }
  
  //MARK: - Private
  private var currentUsername = Variable<String>("")
  private var currentPassword = Variable<String>("")
  private var currentState = Variable<State>(.Initial)
  private var currentValidation: DataValidationFlags = .NonValid {
    didSet {
      self.currentState.value = .ValidationChanged(self.currentValidation)
    }
  }
  
  //MARK: - Observables
  func observeData() -> Observable<DataType> { //Если хотим менять значения извне
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
    case .SignIn:
      self.currentState.value = .Loading
      self.loginAction()
      break
    case .ChangeData(let dataType):
      let valid = dataIsValid(data: dataType)
      var validationFlag = DataValidationFlags.NonValid
      switch (dataType) {
      case .Username(let text):
        self.currentUsername.value = text ?? ""
        validationFlag = .Username
        break
      case .Password(let text):
        self.currentPassword.value = text ?? ""
        validationFlag = .Password
        break
      }
      
      if valid {
        self.currentValidation.insert(validationFlag)
      } else {
        self.currentValidation.remove(validationFlag)
      }
      break
    case .SignUp:
      //unsupported
      break
    }
  }
  
  //MARK: - Validation
  func dataIsValid(data: DataType) -> Bool {
    switch (data) {
    case .Password(let text):
        return (text?.characters.count ?? 0) > 7
    case .Username(let text):
        return (text?.characters.count ?? 0) > 11
    }
  }
  
  //MARK: - Service methods
  func loginAction() {
    let username = self.currentUsername.value 
    let password = self.currentPassword.value
    self.observeLoading(
      ServiceContainer.instance.authService.login(withUser: username, andPassword: password),
      onNext: nil,
      onError: { error in
        self.currentState.value = .Error(error)
      },
      onCompleted: {
        self.currentState.value = .Success
      })
  }
}
