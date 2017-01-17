//
//  TableViewModel.swift
//  mvvm_components
//
//  Created by Andrey Chernov on 11.01.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ObservableArray_RxSwift

class TableViewModel: RxViewModel, ActionViewModel, StateViewModel {
  //MARK: Actions
  typealias ModelAction = Action
  enum Action {
    case SelectItem(Int)
    case JustTap
  }
  
  func accept(action: Action) {
    switch(action) {
    case .SelectItem(let index):
      let item = self.items[index]
      self.currentState.value = .Selected(item)
      //says some service
      break
    case .JustTap:
      print("Tap !")
      let pos = Int(arc4random() % UInt32(items.count))
      items.insert(TableElement(withType: .Default, andData: "\(arc4random() % 10)"), at: pos)
      break
    }
  }
  //MARK: State
  typealias ModelState = State
  enum State {
    case Initial
    case Default
    case Loading
    case Selected(TableElement)
  }
  private var currentState = Variable<State>(.Initial)
  var observeState: Observable<State> { get { return self.currentState.asObservable() } }
  //MARK: Data

  enum ElementType {
    case Default
    case Extra
  }
  
  class TableElement {
    var type: ElementType = .Default
    var data: String = ""
    init(withType eType: ElementType, andData sData: String) {
      self.type = eType
      self.data = sData
    }
  }
  //Can be changed for variable
  private var itemsObservable = BehaviorSubject<[TableElement]>.init(value: [])
  private var items: [TableElement] = [] {
    didSet {
      itemsObservable.onNext(items)
    }
  }
  var observeData: Observable<[TableElement]> { get { return self.itemsObservable.asObservable() } }
    
  func loadData() {
    //TODO: In background?
    self.currentState.value = .Loading
    items.append(TableElement(withType: .Default, andData: "1"))
    items.append(TableElement(withType: .Default, andData: "2"))
    items.append(TableElement(withType: .Extra, andData: "5"))
    items.append(TableElement(withType: .Default, andData: "8"))
    items.append(TableElement(withType: .Extra, andData: "4"))
    self.currentState.value = .Default
  }
}

extension TableViewModel.TableElement: Equatable { //If you want
  public static func ==(lhs: TableViewModel.TableElement, rhs: TableViewModel.TableElement) -> Bool {
    return lhs.type == rhs.type && lhs.data == rhs.data
  }
}
