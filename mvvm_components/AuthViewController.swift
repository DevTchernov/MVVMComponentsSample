//
//  ViewController.swift
//  mvvm_components
//
//  Created by Andrey Chernov on 09.01.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AuthViewController: UIRxComponentsViewController {

  @IBOutlet var authComponent: AuthComponent!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    authComponent.setup()
    
    self.observeAction(
      authComponent.observeState(),
      onNext: { state in
        switch (state) {
        case .Loading:
          self.showProgress()
          break
        case .Success:
          self.hideProgress()
          //Контроллер знает о своих segues но не знает о том что передать дальше
          self.performSegue(withIdentifier: "toMainSegue", sender: nil)
          break
        case .Error(let error):
          self.hideProgress()
          self.showError(error)
          break
        default:
          break
        }
    }, onError: nil, onCompleted: nil)
  }
  
  
  
}
