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

class TableViewModel: RxViewModel {
  
  enum ElementType { //View model говорит что у нее есть данные разного типа, view потом выбирает под них ячейки
    case Default
    case Extra
  }
  class TableElement {
    var type: ElementType = .Default
    var data: Any? = nil
    init(withType eType: ElementType, andData sData: String) {
      self.type = eType
      self.data = sData
    }
  }
  
  private var currentState = Variable<State>(.Initial)
  private var items = ObservableArray<TableElement>()
  
  
  enum State {
    case Initial
    case Default
    case Loading
    case Selected(TableElement)
  }
  
  func loadData() {
    self.currentState.value = .Loading
    items.append(TableElement(withType: .Default, andData: "1"))
    items.append(TableElement(withType: .Default, andData: "2"))
    items.append(TableElement(withType: .Extra, andData: "5"))
    items.append(TableElement(withType: .Default, andData: "8"))
    items.append(TableElement(withType: .Extra, andData: "4"))
    self.currentState.value = .Default
  }
  
  enum Action {
    case SelectItem(Int)
  }
  
  
  func accept(action: Action) {
    switch(action) {
    case .SelectItem(let index):
      let item = self.items[index]
      self.currentState.value = .Selected(item)
      //says some service
      break
    }
  }
  var observeData: Observable<[TableElement]> { get { return self.items.rx_elements() } }
  var observeEvents: Observable<ArrayChangeEvent> { get { return self.items.rx_events() } }
  var observeState: Observable<State> { get { return self.currentState.asObservable() } }
}
