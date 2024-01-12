//
//  SynchronizedSet.swift
//  DataLayer
//
//  Created by Erkan Demir on 18.07.2019.
//  Copyright © 2019 Misli.com. All rights reserved.
//

import Foundation

class SynchronizedSet<Element: Hashable> {
    private var value: Set<Element>
    private let queue: DispatchQueue
    
    init(queue: DispatchQueue) {
        self.queue = queue
        self.value = Set<Element>()
    }
    
    func get() -> Set<Element> {
        return queue.sync {
            value
        }
    }
    
    func set(_ value: Set<Element>) {
        queue.sync(flags: .barrier) {
            self.value = value
        }
    }
    
    func removeAll() {
        queue.sync(flags: .barrier) {
            value.removeAll()
        }
    }
    
    @discardableResult func insert(_ newMember: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        return queue.sync(flags: .barrier) {
            value.insert(newMember)
        }
    }
    
    @discardableResult func update(with newMember: Element) -> Element? {
        return queue.sync(flags: .barrier) {
            value.update(with: newMember)
        }
    }
    
    func contains(_ member: Element) -> Bool {
        return queue.sync {
            value.contains(member)
        }
    }
    
    @discardableResult func remove(_ member: Element) -> Element? {
        return queue.sync(flags: .barrier) {
            value.remove(member)
        }
    }
}
