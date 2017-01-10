//
//  Disposables.swift
//  mvvm_components
//
//  Created by Andrey Chernov on 10.01.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//

import Foundation
import RxSwift

protocol DisposableContainer {
  var disposeBag: DisposeBag! { get }
}
extension DisposableContainer {

  func observe<T>( _ observable: Observable<T>, onScheduler: SchedulerType, onNext: ((T) -> Void)? = nil, onError: ( (Error) -> Void)? = nil, onCompleted: (() -> Void)? = nil ) {
    observable
      .observeOn(onScheduler)
      .subscribe(
        onNext: onNext,
        onError: onError,
        onCompleted: {
          onCompleted?()
      },
        onDisposed: nil)
      .addDisposableTo(self.disposeBag)
  }
}
