//
//  BaseController.swift
//  mvvm_components
//
//  Created by Andrey Chernov on 10.01.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//

import Foundation
import RxSwift

class RxViewModel: NSObject, DisposableContainer {
  var disposeBag: DisposeBag! = DisposeBag()
  private let inputScheduler = SerialDispatchQueueScheduler.init(qos: .userInteractive)
  private let serviceScheduler = SerialDispatchQueueScheduler.init(qos: .background)
  
  func observeInput<T>( _ observable: Observable<T>, onNext: ((T) -> Void)? = nil, onError: ( (Error) -> Void)? = nil, onCompleted: (() -> Void)? = nil ) {
    observe(observable, onScheduler: inputScheduler, onNext: onNext, onError: onError, onCompleted: onCompleted)
  }
  func observeLoading<T>( _ observable: Observable<T>, onNext: ((T) -> Void)? = nil, onError: ( (Error) -> Void)? = nil, onCompleted: (() -> Void)? = nil ) {
    observe(observable, onScheduler: serviceScheduler, onNext: onNext, onError: onError, onCompleted: onCompleted)
  }
}
