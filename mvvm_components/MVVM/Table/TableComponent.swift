//
//  TableComponent.swift
//  mvvm_components
//
//  Created by Andrey Chernov on 11.01.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ObservableArray_RxSwift
import Diff


/*
 Базовый компонент для таблицы - по сути Rx версия AbstractTableView только не надо свой dataSource создавать
 
 */
class TableComponent: MVVMRxComponent {
  @IBOutlet weak var tableView: UITableView!
  @IBInspectable var defaultCellReuseID = ""
  
  private let viewModel = TableViewModel()
  
  //В качестве параметра указываем только базовый класс ячейки которая может принимать данные и кидать события
  typealias Source = UIAbstractReloadableTableSource<DefaultTableViewCell>
  private var supportedCells:[TableViewModel.ElementType: Source.CellConfig] = [:]
  override func setup() {
    //Config
    supportedCells[.Default] =  Source.CellConfig(reuseId: "default", nil, 44)
    supportedCells[.Extra] =  Source.CellConfig(reuseId: "extra", nil, 88)
    
    //TODO: Distinct by reuseID (multiply cell with different keys?)
    for cellType in supportedCells {
      tableView.registerCell(nibName: cellType.value.xibName, reuseId: cellType.value.reuseId)
    }
    
    //Create data stream
    let rxCells = viewModel.observeData.observeOn(MainScheduler.instance).map { $0.map { dataElem -> Source.CellItem in
      return Source.CellItem(
        model: dataElem,
        config: self.supportedCells[dataElem.type]!)
      }
    }
    //Create and link source
    let source = Source()
    viewModel.observeAction(source.cellSelectedObserver.asObservable(), onNext: { index in
      self.viewModel.accept(action: .SelectItem(index.item))
    })
    viewModel.observeAction(source.cellActionObserver.asObservable(), onNext: { action in
      self.viewModel.accept(action: action)
    })
    tableView.dataSource = source
    tableView.delegate = source
    source.subscribe(forData: rxCells, onTableView: tableView)

    //Begin viewModel life
    viewModel.loadData()
  }
  
  //public observe
  func observeState() -> Observable<TableViewModel.State> {
    return viewModel.observeState
  }
}

//TODO: Создать datsSource с простыми фабриками ячейки, высот, рудактирования и пр..
/*
extension UIAbstractTableProtocol where Self:DisposableContainer {

}*/



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
  typealias CellConfig = (reuseId: String, xibName: String? , height: CGFloat? ) //add editable, accessories
  
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
  let cellSelectedObserver = PublishSubject<IndexPath>()
  let cellActionObserver = PublishSubject<Action>()
  
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
      deletionAnimation: .right,
      insertionAnimation: .left)
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
