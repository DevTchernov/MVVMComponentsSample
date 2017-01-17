//
//  Array+Extensions.swift
//  mvvm_components
//
//  Created by Andrey Chernov on 17.01.17.
//  Copyright © 2017 Andrey Chernov. All rights reserved.
//

import Foundation

public extension Sequence {
  func uniq<S>(withSelector select: (Iterator.Element) -> S) -> [Iterator.Element] where S: Hashable {
    return self.reduce([]){
      uniqueElements, element in
      let contains = uniqueElements.contains(where: { checkElem -> Bool in
        return select(element) == select(checkElem)
      })
      return contains ? uniqueElements : (uniqueElements + [element])
    }
  }
  /*
  func distinct(withComparer comparer: (Iterator.Element, Iterator.Element) -> Bool ) -> [Iterator.Element] {
    return self.reduce([]){
      uniqueElements, element in
      let contains = uniqueElements.contains(where: { checkElem -> Bool in
        return comparer(element, checkElem)
      })
      return contains ? uniqueElements : (uniqueElements + [element])
    }
  }*/
}
