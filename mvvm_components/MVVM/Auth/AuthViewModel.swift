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

class AuthViewModel: RxViewModel, ActionViewModel, StateViewModel {
  //MARK: Private
  private let services = ServiceContainer.instance
  
  //MARK: - State
  typealias ModelState = State
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
  
  private var currentState = Variable<State>(.Initial)
  var observeState: Observable<State> { get { return self.currentState.asObservable() } }

  //MARK: Actions
  typealias ModelAction = Action
  enum Action {
    case ChangeData(DataType)
    case SignIn
    case SignUp
  }
  
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
        username.value = text ?? ""
        validationFlag = .Username
        break
      case .Password(let text):
        password.value = text ?? ""
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
  
  func loginAction() {
    self.observeLoading(
      self.services.authService.login(withUser: username.value, andPassword: password.value),
      onNext: nil,
      onError: { error in
        self.currentState.value = .Error(error)
    },
      onCompleted: {
        self.currentState.value = .Success
    })
  }

  
  //MARK: - Data
  enum DataType {
    case Username(String?)
    case Password(String?)
  }
  
  private var username = Variable<String>("")
  private var password = Variable<String>("")
  
  //MARK: - Observables
  func observeData() -> Observable<DataType> { //Если хотим менять значения извне
    return Observable.of(
      username.asObservable().map{ DataType.Username($0) },
      password.asObservable().map{ DataType.Password($0) }).merge()
  }
  
  //MARK: - Validation
  struct DataValidationFlags: OptionSet {
    let rawValue: Int
    static let NonValid = DataValidationFlags(rawValue: 0)
    static let Username = DataValidationFlags(rawValue: 1)
    static let Password = DataValidationFlags(rawValue: 2)
    static let Valid: DataValidationFlags = [.Username, .Password]
  }
  
  private var currentValidation: DataValidationFlags = .NonValid {
    didSet {
      self.currentState.value = .ValidationChanged(self.currentValidation)
    }
  }

  func dataIsValid(data: DataType) -> Bool {
    switch (data) {
    case .Password(let text):
        return (text?.characters.count ?? 0) > 7
    case .Username(let text):
        return (text?.characters.count ?? 0) > 11
    }
  }
  
}


