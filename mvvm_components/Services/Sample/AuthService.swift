//
//  AuthService.swift
//  mvvm_components
//
//  Created by Andrey Chernov on 10.01.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//

import Foundation
import RxSwift
import IRDSwiftCoreModule

/*
 Base variant
 */
class AuthService {
  static let instance = AuthService()
  
  enum Errors: ErrorsProtocol {
    case IncorrectData
    
    ///Домен - имя сервиса
    static var Domain = "AuthService"
    ///Код ошибки и описание
    var errorInfo : ErrorInfo {
      get {
        switch(self) {
          case .IncorrectData:
            return ErrorInfo(code: 1, description: "Incorrect username or password")
        }
      }
    }
  }
  
  func login(withUser username: String, andPassword password: String) -> Observable<Void> {
    return password.contains("1234") ? Observable.just() : Observable.error(Errors.IncorrectData.ErrorType())
  }
}

