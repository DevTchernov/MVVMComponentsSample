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
  /*
   override it
   */
  func setup() {
  }
}

class MVVMRxComponent: MVVMComponent, DisposableContainer {
  var disposeBag:DisposeBag! = DisposeBag()
  deinit {
    disposeBag = nil
  }
}
