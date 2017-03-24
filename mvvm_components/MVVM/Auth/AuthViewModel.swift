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
  
  enum Mode {
    case SignIn
    case SignUp
  }
  
  private var currentMode: Mode = .SignIn
  
  private var currentState = Variable<State>(.Initial)
  var observeState: Observable<State> { get { return self.currentState.asObservable() } }

  //MARK: Actions
  typealias ModelAction = Action
  enum Action {
    case ChangeData(DataType)
    case ChangeMode(Mode)
    case Login
  }
  
  func accept(action: Action) {
    switch(action) {
    case .ChangeMode(let mode):
      self.currentMode = mode
      break
    case .Login:
      self.currentState.value = .Loading
      switch (self.currentMode) {
      case .SignIn:
        self.loginAction()
        break
      case .SignUp:
        //unsopported?
        break
      }
      
      break
    case .ChangeData(let dataType):
      let valid = dataIsValid(data: dataType)
      var validationFlag = DataValidationFlags.NonValid
      switch (dataType) {
      case .Username(let text):
        username = text ?? ""
        validationFlag = .Username
        break
      case .Password(let text):
        password = text ?? ""
        validationFlag = .Password
        break
      case .RepeatPassword(let text):
        repassword = text ?? ""
        validationFlag = .RepeatPassword
      }
      
      if valid {
        self.currentValidation.insert(validationFlag)
      } else {
        self.currentValidation.remove(validationFlag)
      }
      break
    }
  }
  
  func loginAction() {
    self.observeLoading(
      self.services.authService.login(withUser: username, andPassword: password),
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
    case RepeatPassword(String?)
  }
  
  private var username: String = ""
  private var password: String = ""
  private var repassword: String = ""
  
  //MARK: - Observables
  func observeData() -> Observable<DataType> {
    //Ничего не можем вернуть (возвращали если бфло бы, например, автозаполнение предыдущим логином)
    return Observable.empty()
  }
  
  //MARK: - Validation
  struct DataValidationFlags: OptionSet, Hashable {
    let rawValue: Int
    static let NonValid = DataValidationFlags(rawValue: 0)
    static let Username = DataValidationFlags(rawValue: 1)
    static let Password = DataValidationFlags(rawValue: 2)
    static let RepeatPassword = DataValidationFlags(rawValue: 4)
    static let Valid: DataValidationFlags = [.Username, .Password, RepeatPassword]
    var hashValue: Int {
      return rawValue
    }
  }
  
  private var currentValidation: DataValidationFlags = .NonValid {
    didSet {
      self.currentState.value = .ValidationChanged(self.currentValidation)
    }
  }

  func dataIsValid(data: DataType) -> Bool {
    switch (data) {
    case .Username(let text):
        return (text?.characters.count ?? 0) > 11
    case .Password(let text):
      switch currentMode {
      case .SignUp:
        return passIsValid(password: text) && (repassword == "" ? true : text == self.repassword)
      case .SignIn:
        return true //try to login with any password
      }
    case .RepeatPassword(let text):
      return passIsValid(password: text) && text == self.password
    }
  }
  
  private func passIsValid(password: String?) -> Bool {
    return (password?.characters.count ?? 0) > 7
  }
  
}


