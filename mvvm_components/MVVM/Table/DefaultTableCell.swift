//
//  DefaultTableCell.swift
//  mvvm_components
//
//  Created by Andrey Chernov on 13.01.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//

import Foundation
class DefaultTableViewCell : RxCustomActionCell, FillableCellProtocol {
  func update(_ data: Any?) {
  }
  //var actionsProvider: UICellActionProvider? = nil
  
  func fill(_ data: Any?) {
    self.textLabel?.text = "\(data)"
  }
}
