//
//  BaseComponent.swift
//  mvvm_components
//
//  Created by Andrey Chernov on 10.01.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//

import Foundation
import RxSwift

class MVVMComponent: NSObject {
  private var wasSetuped = false
  func setup(with initialObject: Any? = nil) {
    //override it
  }
}

class MVVMRxComponent: MVVMComponent, DisposableContainer {
  var disposeBag:DisposeBag! = DisposeBag()
  deinit {
    disposeBag = nil
  }
}
