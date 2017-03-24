//
//  NOTextField+Rx.swift
//  mvvm_netoptica
//
//  Created by Andrey Chernov on 23.03.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base: NOTextField {
  var text: ControlProperty<String?> {
    return base.textField.rx.text
  }
}
