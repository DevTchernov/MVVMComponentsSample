//
//  UIViewController+RxMVVM.swift
//  mvvm_components
//
//  Created by Andrey Chernov on 10.01.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//

import Foundation
import RxSwift

class UIRxComponentsViewController: UIRxViewController {
  @IBOutlet var components: [MVVMComponent]!  //Чтобы не терять ссылки  
}
