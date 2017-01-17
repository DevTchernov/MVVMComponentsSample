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
 Базовый компонент для таблицы
 */
class TableComponent: MVVMRxComponent {
  /*
   * Обязательно для регистрации ячеек и перезагрузки данных при изменении
   */
  @IBOutlet weak var tableView: UITableView!
  
  /*
   * ViewModel должен как-то уметь выдавать Observable<[Element]>
   */
  private let viewModel = TableViewModel()
  
  /*
   * DefaultTableViewCell - класс ячейки от которого должны наследоваться все используемые с этим viewModel'ом (это по факту не проверяется и можно даже переопределить dataSource)
   */
  typealias BaseCell = DefaultTableViewCell
  
  /*
   * Используемый класс DataSource
   */
  typealias Source = UIAbstractReloadableTableSource<BaseCell>
  
  /*
   * Типы ячеек
   */
  var supportedCells:[TableViewModel.ElementType: CellConfig] = [:]
  //Компонент поддерживает несколько вариантов настройки извне (по умолчанию и с параметрами)
  private var wasSetuped = false
  override func setup(with object: Any? = nil) {
    super.setup(with: object)
    guard wasSetuped == false else { return }
    wasSetuped = true
    //Выбираем поддерживаемые ячейки
    //xibName = nil если ячейка уже зарегистрирована в таблице (на storyboard например)
    supportedCells[.Default] =  CellConfig(reuseId: "default", xibName: nil, 44)
    supportedCells[.Extra] =  CellConfig(reuseId: "extra", xibName: nil, 88)
    
    registerCells()
    linkViewModel()

    //Begin viewModel life
    viewModel.loadData(for: object)
  }
  
  /*
   * Регистрируем все неповторяющиеся reuseID
   */
  private func registerCells() {
    for cellType in supportedCells.values.uniq(withSelector: { $0.reuseId }) {
      tableView.registerCell(nibName: cellType.xibName, reuseId: cellType.reuseId)
    }
  }
  
  /*
   * Связываем dataSource и viewModel
   */
  private func linkViewModel() {
    //Создаем dataSource и цепляем действия из него к viewModel
    let source = Source()
    viewModel.bindActions(
      from: source.cellSelectedObserver.asObservable()
        .map{ .CellAction(action: .Select, index: $0.item )  })
    
    viewModel.bindActions(
      from: source.cellActionObserver.asObservable()
        .map{ .CellAction(action: $0.action, index: self.tableView.indexPath(for: $0.cell)?.item ?? -1) })
    
    //А данные из viewModel к dataSource
    let rxCells = viewModel.observeData.observeOn(MainScheduler.instance).map { $0.map { dataElem -> Source.CellItem in
      return Source.CellItem(
        model: dataElem,
        config: self.supportedCells[dataElem.type]!)
      }
    }
    
    tableView.dataSource = source
    tableView.delegate = source
    source.subscribe(forData: rxCells, onTableView: tableView)
  }
  
  /*
   * Состояние компонента
   */
  func observeState() -> Observable<TableViewModel.State> {
    return viewModel.observeState
  }
}





