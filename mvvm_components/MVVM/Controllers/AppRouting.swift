//
//  AppRouting.swift
//  mvvm_components
//
//  Created by Andrey Chernov on 25.01.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//

import Foundation
import UIKit

/*
 * Доопредляем переходы не по segues (они определены еще в UIRxComponentsViewController)
 */
class AppRouter {
  
  enum NavigationTypes {
    case Segue(withID: String)
    enum ShowingType {
      case Push
      case Present
    }
    case Instantiate(withID: String, andType: ShowingType)
  }
  
  static func navigate(from: UIViewController, by: NavigationTypes, withParam param: Any?) {
    switch (by) {
    case .Instantiate(let id, let showType):
      if let vc = from.storyboard?.instantiateViewController(withIdentifier: id) {
        
        (vc as? UIRxComponentsViewController)?.initialObject = param
        
        switch(showType) {
        case .Push:
          from.navigationController?.pushViewController(vc, animated: true)
          break
        case .Present:
          from.present(vc, animated: true, completion: nil)
          break
        }
      }
      break
    case .Segue(let id):
      from.performSegue(withIdentifier: id, sender: param)
      break
    }
  }
}

protocol IAppRouteController {
  func navigate(byType type: AppRouter.NavigationTypes, withParam param: Any?)
}

extension UIRxComponentsViewController: IAppRouteController {
  //MARK: App router
  func navigate(byType type: AppRouter.NavigationTypes, withParam param: Any?) {
    AppRouter.navigate(from: self, by: type, withParam: param)
  }
}
