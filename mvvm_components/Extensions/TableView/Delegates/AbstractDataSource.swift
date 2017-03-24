//
//  AbstractDataSource.swift
//  mvvm_components
//
//  Created by Andrey Chernov on 16.01.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Diff

typealias CellConfig = (reuseId: String, xibName: String? , height: CGFloat? ) //add editable, accessories
class UIAbstractTableSource<CellType : FillableCellProtocol & ActionCellProtocol>: _AbstractStubDelegate, DisposableContainer {
  typealias Element = CellType.DataType
  typealias Action = CellType.ActionType
  //MARK: - Disposable
  var disposeBag:DisposeBag! = DisposeBag()
  
  deinit {
    disposeBag = nil
  }
  
  //MARK: - Types
  typealias CellItem = (model: Element, config: CellConfig)
  
  //MARK: - Items, load
  var items:[CellItem] = []
  
  func subscribe(forData: Observable<[CellItem]>, onTableView tableView: UITableView) {
    self.observeAction(forData, onNext: { newItems in
      let oldItems = self.items
      self.items = newItems
      self.reloadTable(tableView: tableView, fromItems: oldItems);
    }, onError: nil, onCompleted: nil)
  }
  
  //MARK: - Cell's custom actions
  let cellSelectedObserver = PublishSubject<IndexPath>() //cell selection event
  let cellActionObserver = PublishSubject<(cell: UITableViewCell, action: Action)>() //cell custom events
  //let tableActionObserver //can be events/gestures on tableView (refresh/etc)
  
  func reloadTable(tableView: UITableView, fromItems: [CellItem]) {
    tableView.reloadData()
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let item = items[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: item.config.reuseId, for: indexPath)
    (cell as? CellType)?.actionObserver = self.cellActionObserver.asObserver()
    (cell as? CellType)?.fill(item.model)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let item = items[indexPath.row]
    (cell as? CellType)?.update(item.model)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let item = items[indexPath.row]
    return item.config.height ?? tableView.rowHeight
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    cellSelectedObserver.onNext(indexPath)
  }
}

class UIAbstractReloadableTableSource<CellType: FillableCellProtocol & ActionCellProtocol>: UIAbstractTableSource<CellType> where CellType.DataType: Equatable {
  
  override func reloadTable(tableView: UITableView, fromItems: [CellItem]) {
    tableView.animateRowChanges(
      oldData: fromItems.map{ $0.model },
      newData: self.items.map{ $0.model },
      deletionAnimation: .left,
      insertionAnimation: .middle)
  }
}

class _AbstractStubDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func _tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return _tableView(tableView, numberOfRowsInSection: section)
  }
  
  fileprivate func _tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    fatalError("Abstract method")
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return _tableView(tableView, cellForRowAt: indexPath)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableView.rowHeight
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
  }
}
