//
//  UIRxView+Bindings.swift
//  mvvm_components
//
//  Created by Andrey Chernov on 10.01.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

//MARK: - Bind different types of observableTypes to viewModel method
extension DisposableContainer {
  
  func bindObservable<E, A>(observable: Observable<E?>?, withFabric actionFabric: @escaping ((E?) -> (A)), toAction action: @escaping (A) -> Void ) {
    self.bindDriver(driver: observable?.asDriver(onErrorJustReturn: nil), withFabric: actionFabric, toAction: action)
  }
  
  func bindControlProperty<E, A>(controlProperty: ControlProperty<E?>?, withFabric actionFabric: @escaping ((E?) -> (A)), toAction action: @escaping (A) -> Void ) {
    self.bindDriver(driver: controlProperty?.asDriver(), withFabric: actionFabric, toAction: action)
  }
  
  func bindControlEvent<A>(controlEvent: ControlEvent<Void>?, withFabric actionFabric: @escaping (Void) -> (A), toAction action: @escaping (A) -> Void ) {
    guard let driver = controlEvent?.asDriver() else { return }
    driver.map({actionFabric($0)}).drive(onNext: action, onCompleted: nil, onDisposed: nil).addDisposableTo(self.disposeBag)
  }

  func bindDriver<E, A>(driver: Driver<E?>?, withFabric actionFabric: @escaping ((E?) -> (A)), toAction action: @escaping (A) -> Void ) {
    guard let driver = driver else { return }
    driver.map({actionFabric($0)}).drive(onNext: action, onCompleted: nil, onDisposed: nil).addDisposableTo(self.disposeBag)
  }

}
