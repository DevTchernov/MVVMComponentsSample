//
//  UIView+Rx.swift
//  mvvm_components
//
//  Created by Andrey Chernov on 10.01.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//

import Foundation
import RxSwift

class UIRxView: UIView, DisposableContainer {
  
  var disposeBag:DisposeBag! = DisposeBag()
  deinit {
    self.disposeBag = nil
  }
}
