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
  var initialObject: Any? = nil //Для настройки компонентов
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    for component in components {
      component.setup(with: initialObject)
    }
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    (segue.destination as? UIRxComponentsViewController)?.initialObject = sender
  }
}
