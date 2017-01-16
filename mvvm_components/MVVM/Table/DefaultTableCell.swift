//
//  DefaultTableCell.swift
//  mvvm_components
//
//  Created by Andrey Chernov on 13.01.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//
import Foundation
import RxSwift

/*
 Базовая модель для ячейки:
 указываем из данных какого типа ячейка может заполняться (не поддерживаются разные классы - лучше использовать enum а в крайних случаях - Any)
 указываем действия какого типа может генерироваться ячейка (также enum / Any )
 */
class DefaultTableViewCell: UITableViewCell, ActionCellProtocol, FillableCellProtocol {
  typealias ActionType = TableViewModel.Action
  typealias DataType = TableViewModel.TableElement
  var actionObserver: AnyObserver<ActionType>? = nil
  func update(_ data: DataType) {
    
  }
  
  func fill(_ data: DataType) {
    self.textLabel?.text = "\(data.data)"
    self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapOnText)))
  }
  
  func tapOnText(gesture: UITapGestureRecognizer) {
    actionObserver?.onNext(.JustTap)
  }
}
