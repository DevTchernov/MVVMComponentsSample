//
//  UITableView+extensions.swift
//  mvvm_components
//
//  Created by Andrey Chernov on 13.01.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

//Делегат по умолчанию
class _RxTableViewHeightDelegate : NSObject, UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableView.rowHeight
  }
}
//От элемента с фабрикой для высоты
class RxTableViewHeightDelegate<Element>: _RxTableViewHeightDelegate {
  typealias HeightFactory = (UITableView, IndexPath, Element) -> CGFloat?
  
  let heightFactory: HeightFactory
  
  init(heightFactory: @escaping HeightFactory) {
    self.heightFactory = heightFactory
  }
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let model:Element = try? tableView.rx.model(at: indexPath) else {
      return tableView.rowHeight
    }
    return heightFactory(tableView, indexPath, model) ?? tableView.rowHeight
  }  
}

//Агрегатор для переход от коллекции
class RxTableViewReactiveArrayDelegateSequenceWrapper<S: Sequence>
: RxTableViewHeightDelegate<S.Iterator.Element>, RxTableViewHeightDelegateType {
  typealias Element = S
  
  override init(heightFactory: @escaping HeightFactory) {
    super.init(heightFactory: heightFactory)
  }
}
//Просто нужен для передачи элемента внутрь фабрики
public protocol RxTableViewHeightDelegateType /*: UITableViewDataSource*/ {
  
  /// Type of elements that can be bound to table view.
  associatedtype Element
}

//Собственно сами точки подписки
extension Reactive where Base:UITableView {
  
  public func heights<S: Sequence, O: ObservableType>
    (_ source: O)
    -> (_ heightFactory: @escaping (UITableView, IndexPath, S.Iterator.Element) -> CGFloat?)
    -> Disposable
    where O.E == S {
      return { heightsFactory in
        let delegate = RxTableViewReactiveArrayDelegateSequenceWrapper<S>.init(heightFactory: heightsFactory)
        return self.heights(delegate: delegate)(source)
      }
  }
  
  public func heights<
    Delegate: RxTableViewHeightDelegateType & UITableViewDelegate,
    O: ObservableType>
    (delegate: Delegate)
    -> (_ source: O)
    -> Disposable
    where Delegate.Element == O.E {
      return { source in
        // This is called for sideeffects only, and to make sure delegate proxy is in place when
        // data source is being bound.
        // This is needed because theoretically the data source subscription itself might
        // call `self.rx.delegate`. If that happens, it might cause weird side effects since
        // setting data source will set delegate, and UITableView might get into a weird state.
        // Therefore it's better to set delegate proxy first, just to be sure.
        //_ = self.delegate
        // Strong reference is needed because data source is in use until result subscription is disposed
        return source.subscribeProxyDelegate(ofObject: self.base, delegate: delegate, retainDataSource: true) { [weak tableView = self.base] (_: RxTableViewDelegateProxy, event) -> Void in
        }
      }
  }
}

//Создает делегат, подписывается на его события, убивает подписку
extension ObservableType {
  func subscribeProxyDelegate<P: DelegateProxyType>(ofObject object: UIView, delegate: AnyObject, retainDataSource: Bool, binding: @escaping (P, Event<E>) -> Void)
    -> Disposable {
      let proxy = P.proxyForObject(object)
      let unregisterDelegate = P.installForwardDelegate(delegate, retainDelegate: retainDataSource, onProxyForObject: object)
      // this is needed to flush any delayed old state (https://github.com/RxSwiftCommunity/RxDataSources/pull/75)
      object.layoutIfNeeded()
      
      let subscription = self.asObservable()
        .observeOn(MainScheduler())
        .catchError { error in
          bindingErrorToInterface(error)
          return Observable.empty()
        }
        // source can never end, otherwise it would release the subscriber, and deallocate the data source
        .concat(Observable.never())
        .takeUntil(object.rx.deallocated)
        .subscribe { [weak object] (event: Event<E>) in
          
          if let object = object {
            assert(proxy === P.currentDelegateFor(object), "Proxy changed from the time it was first set.\nOriginal: \(proxy)\nExisting: \(P.currentDelegateFor(object))")
          }
          
          binding(proxy, event)
          
          switch event {
          case .error(let error):
            bindingErrorToInterface(error)
            unregisterDelegate.dispose()
          case .completed:
            unregisterDelegate.dispose()
          default:
            break
          }
      }
      
      return Disposables.create { [weak object] in
        subscription.dispose()
        unregisterDelegate.dispose()
        object?.layoutIfNeeded()
      }
  }
}

func bindingErrorToInterface(_ error: Swift.Error) {
  let error = "Binding error to UI: \(error)"
  #if DEBUG
    fatalError(error)
  #else
    print(error)
  #endif
}
