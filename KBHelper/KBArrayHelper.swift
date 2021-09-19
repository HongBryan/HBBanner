//
//  HKArrayHelper.swift
//  HKBase
//
//  Created by Bryan on 2021/9/16.
//
//  说明:数组拓展类

import Foundation
extension Array {
    func kb_object(at index: Int) -> Element? {
        if index < 0 {
            return nil
        }
        if index >= count {
            return nil
        }
        return self[index]
    }
    
    mutating func kb_remove(at index: Int?) {
        guard let _index = index else {
            return
        }
        if count <= _index || _index < 0 {
            return
        }
        remove(at: _index)
    }
    
    mutating func kb_replace(of index: Int, newElement: Element? ) {
        guard let _newElement = newElement else {
            return
        }
        if count <= index {
            return
        }
        self[index] = _newElement
    }
    
    mutating func kb_append(_ newElement: Element?) {
        if newElement == nil {
            return
        }
        self.append(newElement!)
    }
    
    mutating func kb_append<S>(contentsOf newElements: S?) where Element == S.Element, S : Sequence {
        if newElements == nil {
            return
        }
        self.append(contentsOf: newElements!)
    }
    
    mutating func kb_remove(in indexs:[Int]) {
        for itemIndex in indexs {
            self.remove(at: itemIndex)
        }
    }
    
    func kb_elementsEqual(otherElements: Self?) -> Bool {
        guard let elements = otherElements else {
            return false
        }
        if count != elements.count {
            return false
        }
        return true
    }
}
