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
	//Don't call super.fill()
	func fill(_ data: Any?)
	func update(_ data: Any?)
}

//MARK: - Custom cell actions

class RxCustomActionCell: UITableViewCell {
  private let actionSubject = PublishSubject<Any>()
  var actionDriver: Driver<Any> {
    get {
      return actionSubject
        .map({ any -> Any? in
          return any
        })
        .asDriver(onErrorJustReturn: nil)
        .filter{ $0 != nil }
        .map{ $0! }
    }
  }
  
  func forceAction(withParam param: Any) {
    
  }
  deinit {
    actionSubject.dispose()
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
