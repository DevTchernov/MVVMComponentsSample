//
//  UITableView+Rx.swift
//  mvvm_components
//
//  Created by Andrey Chernov on 13.01.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//

import Foundation
import ObservableArray_RxSwift
import RxSwift

extension UITableView {
  public func rx_autoUpdater(source: Observable<ArrayChangeEvent>) -> Disposable {
    return source
      .scan((0, nil)) { (a: (Int, ArrayChangeEvent?), ev) in
        return (a.0 + ev.insertedIndices.count - ev.deletedIndices.count, ev)
      }
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { sourceCount, event in
        guard let event = event else { return }
        
        let tableCount = self.numberOfRows(inSection: 0)
        guard tableCount + event.insertedIndices.count - event.deletedIndices.count == sourceCount else {
          self.reloadData()
          return
        }
        
        
        func toIndexSet(array: [Int]) -> [IndexPath] {
          return array.map { IndexPath(row: $0, section: 0) }
        }
        
        self.beginUpdates()
        self.deleteRows(at: toIndexSet(array: event.deletedIndices), with: .automatic)
        self.insertRows(at: toIndexSet(array: event.insertedIndices), with: .automatic)
        self.reloadRows(at: toIndexSet(array: event.updatedIndices), with: .automatic)
        self.endUpdates()
      })
  }
}
