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
  typealias ActionType = TableViewModel.Actions.Cell
  
  var actionObserver: AnyObserver<(cell: UITableViewCell, action: ActionType)>? = nil
  
  //MARK: DataType
  typealias DataType = TableViewModel.TableElement  
  
  func fill(_ data: DataType) {
    self.textLabel?.text = "\(data.data)"
    
    let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeOnText))
    swipe.direction = .left
    swipe.cancelsTouchesInView = false
    self.addGestureRecognizer(swipe)
  }

  func update(_ data: DataType) {
    //you can load something..
  }
  
  func swipeOnText(gesture: UISwipeGestureRecognizer) {
    actionObserver?.onNext((cell: self,action: .SwipeLeft))
  }
}
