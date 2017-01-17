//
//  UITableViewCell+extensions.swift
//  ServedIn
//
//  Created by Andrey Chernov on 14.09.16.
//  Copyright © 2016 Andrey Chernov. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

//MARK: - Fillable
protocol FillableCellProtocol {
  associatedtype DataType
  //Don't call super.fill()
  func fill(_ data: DataType)
  func update(_ data: DataType)
}

//MARK: - Custom cell actions

protocol ActionCellProtocol: class {
  associatedtype ActionType
  var actionObserver: AnyObserver<ActionType>? { get set }
}
extension ActionCellProtocol {
  func sendAction(withType type: ActionType) {
    actionObserver?.onNext(type)
  }
}
