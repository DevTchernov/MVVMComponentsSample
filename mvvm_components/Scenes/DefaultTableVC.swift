//
//  DefaultTableVC.swift
//  mvvm_components
//
//  Created by Andrey Chernov on 13.01.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//

import Foundation
import UIKit

class DefaultTableVC: UIRxComponentsViewController {
  @IBOutlet var tableComponent: TableComponent!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //На уровне контроллера говорим какие ячейки должен уметь принимать компонент таблицы
    //Дальше они сами договорятся если соблюсти все протоколы
    
    self.observeAction(
      self.tableComponent.observeState(),
      onNext: { state in
        switch(state) {
        case .Initial:
          break
        case .Loading:
          self.showProgress()
          break
        case .Default:
          self.hideProgress()
          break
        case .SelectedDefault(let element):
          print("Selected \(element)") //some model object selected - show detail view with setup
          AppRouter.navigate(from: self, by: AppRouter.Navigations.DefaultToDefault, withParam: element)
          //Navigate?
          break
        case .SelectedExtra(let element):
          //show subfolder
          AppRouter.navigate(from: self, by: AppRouter.Navigations.DefaultToExtra, withParam: element)
          break
        }
    },
      onError: nil,
      onCompleted: nil)
    tableComponent.setup(with: initialObject)
  }
  
  func setup(with object: Any?) {
    self.initialObject = object
    self.loadViewIfNeeded()
  }
}

/*
 * Доопредляем переходы не по segues (те определены еще в UIRxComponentsViewController)
 */
class AppRouter {
  typealias NavigationUnit = (type: Navigations.Types, id: String)
  enum Navigations {
    enum Types {
      case Segue
      enum ShowingType {
        case Push
        case Present
      }
      case Instantiate(ShowingType)
    }
    static let DefaultToDefault:  NavigationUnit = (.Segue, id: "defaultToDefault")
    static let DefaultToExtra:    NavigationUnit = (.Instantiate(.Push), id: "DefaultTableVC_ID")
  }
  
  static func navigate(from: UIViewController, by: NavigationUnit, withParam param: Any?) {
    switch (by.type) {
    case .Instantiate(let showType):
      if let vc = from.storyboard?.instantiateViewController(withIdentifier: by.id) {
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
    case .Segue:
      from.performSegue(withIdentifier: by.id, sender: param)
      break
    }
  }
}
