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
  //MARK: ActionType
  typealias ActionType = TableViewModel.Action
  var actionObserver: AnyObserver<ActionType>? = nil
  
  //MARK: DataType
  typealias DataType = TableViewModel.TableElement
  
  func fill(_ data: DataType) {
    self.textLabel?.text = "\(data.data)"
  }

  func update(_ data: DataType) {
    //you can load something..
  }
  
  func tapOnText(gesture: UITapGestureRecognizer) {
    actionObserver?.onNext(.JustTap)
  }
}
