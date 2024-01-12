//
//  SynchronizedDictionary.swift
//  DataLayer
//
//  Created by Erkan Demir on 18.07.2019.
//  Copyright © 2019 Misli.com. All rights reserved.
//

import Foundation

class SynchronizedDictionary<Key: Hashable, Value> {
    private var value: [Key: Value]
    private let queue: DispatchQueue
    
    init(queue: DispatchQueue) {
        self.queue = queue
        self.value = [Key: Value]()
    }
    
    func get() -> [Key: Value] {
        return queue.sync {
            value
        }
    }
    
    func set(_ value: [Key: Value]) {
        queue.sync(flags: .barrier) {
            self.value = value
        }
    }
    
    func removeAll() {
        queue.sync(flags: .barrier) {
            value.removeAll()
        }
    }
    
    subscript(key: Key) -> Value? {
        get {
            return queue.sync {
                value[key]
            }
        }
        set {
            queue.sync(flags: .barrier) {
                value[key] = newValue
            }
        }
    }
    
}
