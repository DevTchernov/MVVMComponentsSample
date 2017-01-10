//
//  ServiceContainer.swift
//  mvvm_components
//
//  Created by Andrey Chernov on 10.01.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//

import Foundation

class ServiceContainer {
  static let instance = ServiceContainer()
  
  var authService: AuthService {
    get {
      return AuthService()
      //или return AuthService.instance
    }
  }
}
