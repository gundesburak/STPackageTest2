//
//  Array.swift
//  Misli.com
//
//  Created by ilyas Y on 12.10.2020.
//  Copyright © 2020 Misli.com. All rights reserved.
//

import Foundation

public extension Array {
    var middle: Element? {
        guard !isEmpty else { return nil }

        let middleIndex = (count > 1 ? count - 1 : count) / 2
        return self[middleIndex]
    }
    
    func safelyAccessElement(at index: Int) -> Element? {
           guard indices.contains(index) else {
               return nil
           }

           return self[index]
       }
    
}
public extension Collection where Element: Collection {
    func contains(index: Index, subIndex: Element.Index) -> Bool {
       indices.contains(index) && self[index].indices.contains(subIndex)
   }
}
