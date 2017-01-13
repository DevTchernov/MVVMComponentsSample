//
//  DefaultTableVC.swift
//  mvvm_components
//
//  Created by Andrey Chernov on 13.01.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//

import Foundation

class DefaultTableVC: UIRxComponentsViewController {
  
  @IBOutlet var tableComponent: TableComponent!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableComponent.setup()
    
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
        case .Selected(_):
          //Navigate?
          break
        }
      },
      onError: nil,
      onCompleted: nil)
  }
}
