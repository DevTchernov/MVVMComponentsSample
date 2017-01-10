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
  
  func observeAction<T>( _ observable: Observable<T>, onNext: ((T) -> Void)? = nil, onError: ( (Error) -> Void)? = nil, onCompleted: (() -> Void)? = nil ) {
    observe(observable, onScheduler: MainScheduler.instance, onNext: onNext, onError: onError, onCompleted: onCompleted)
  }
  
  var disposeBag:DisposeBag! = DisposeBag()
  deinit {
    self.disposeBag = nil
  }
}
