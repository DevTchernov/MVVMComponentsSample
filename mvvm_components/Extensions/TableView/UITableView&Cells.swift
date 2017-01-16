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

extension UITableView {
  func registerCell(nibName: String?, reuseId: String) {
    if let xib = nibName {
      self.register(UINib(nibName: xib, bundle: Bundle.main), forCellReuseIdentifier: reuseId)
    }
  }
}

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

extension UITableViewCell {
  func setSeparatorInsert(insets:UIEdgeInsets = .zero) {
    if self.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
      self.separatorInset = insets
    }
    
    if self.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins))  {
      self.preservesSuperviewLayoutMargins = false
    }
    
    if self.responds(to: #selector(setter: UIView.layoutMargins))  {
      self.layoutMargins = insets
    }
  }
}
