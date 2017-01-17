//
//  UITableView+Misc.swift
//  mvvm_components
//
//  Created by Andrey Chernov on 16.01.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
  func registerCell(nibName: String?, reuseId: String) {
    if let xib = nibName {
      self.register(UINib(nibName: xib, bundle: Bundle.main), forCellReuseIdentifier: reuseId)
    }
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
