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

/*
 Базовый компонент для таблицы - по сути Rx версия AbstractTableView только не надо свой dataSource создавать
 
 */
class TableComponent: MVVMRxComponent {
  @IBOutlet weak var tableView: UITableView!
  @IBInspectable var defaultCellReuseID = ""
  
  private let viewModel = TableViewModel()
  typealias Element = TableViewModel.TableElement
  
  var supportedCells: [TableViewModel.ElementType: (reuseId: String, xibName: String?, cellType: UITableViewCell.Type)] = [:]
  
  override func setup() {
    //Config
    supportedCells[.Default] =  (reuseId: "default",  xibName: nil, cellType: DefaultTableViewCell.self)
    supportedCells[.Extra] =    (reuseId: "extra",    xibName: nil, cellType: DefaultTableViewCell.self)
    
    //Register - relocate to another method?
    for cellType in self.supportedCells {
      tableView.registerCell(nibName: cellType.value.xibName, reuseId: cellType.value.reuseId)
    }
    
    //Observe model data and changes (if supports)
    viewModel.observeData.bindTo(tableView.rx.items) { (tableView, row, element) -> UITableViewCell in
      return self.getCell(in: tableView, onRow: row, by: element)
    }.addDisposableTo(self.disposeBag)
    
    viewModel.observeEvents.bindTo(tableView.rx_autoUpdater).addDisposableTo(self.disposeBag)
    
    //Observe cell heights ?
    viewModel.observeData.bindTo(tableView.rx.heights) { (tableView, index, element) -> CGFloat? in
      return CGFloat(( 1 + index.row % 2 ) * 44)
      }.addDisposableTo(self.disposeBag)
    
    //Begin viewModel life
    viewModel.loadData()
  }
  
  //override in childs?
  func getCell(in tableView: UITableView, onRow row: Int, by viewModelObject: Element ) -> UITableViewCell {
    guard let cellConfig = supportedCells[viewModelObject.type] else {
      fatalError("Unsupported cell \(viewModelObject.type)")
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: cellConfig.reuseId, for: IndexPath.init(row: row, section: 0))
    (cell as? FillableCellProtocol)?.fill(viewModelObject.data)
    (cell as? RxCustomActionCell)?.actionDriver.drive(onNext: { param in
      //TODO:
      //convert param from action to viewMode method
    }).addDisposableTo(self.disposeBag)
    return cell
  }
  
  //public observe
  func observeState() -> Observable<TableViewModel.State> {
    return viewModel.observeState
  }
}

