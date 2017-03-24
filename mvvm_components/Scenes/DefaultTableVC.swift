//
//  DefaultTableVC.swift
//  mvvm_components
//
//  Created by Andrey Chernov on 13.01.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//

import Foundation
import UIKit

class DefaultTableVC: UIRxComponentsViewController {
  @IBOutlet var tableComponent: TableComponent!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //На уровне контроллера говорим какие ячейки должен уметь принимать компонент таблицы
    //Дальше они сами договорятся если соблюсти все протоколы
    
    self.observeAction(
      self.tableComponent.observeState(),
      onNext: { state in
        switch(state) {
        case .Initial:
          break
        case .Loading:
          self.showProgress()
          break
        case .Default:
          self.hideProgress()
          break
        case .Selected(let data, let type):
          switch(type) {
          case .Default:
            self.navigate(byType: Routing.ToDefault, withParam: data)
            break
          case .Extra:
            self.navigate(byType: Routing.ToExtra, withParam: data)
            break
          }
          break
        }
    },
      onError: nil,
      onCompleted: nil)
    
    tableComponent.setup(with: initialObject)
  }
  
  //MARK: - Routing
  struct Routing {
    static let ToDefault = AppRouter.NavigationTypes.Segue(withID: "defaultToDefault")
    static let ToExtra = AppRouter.NavigationTypes.Instantiate(withID: "DefaultTableVC_ID", andType: .Push)
  }  
}
