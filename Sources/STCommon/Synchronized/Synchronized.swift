//
//  ThreadSafeVariable.swift
//  DataLayer
//
//  Created by Erkan Demir on 16.07.2019.
//  Copyright © 2019 Misli.com. All rights reserved.
//

import Foundation

class Synchronized<T> {
    private var value: T?
    private let queue: DispatchQueue
    
    init(queue: DispatchQueue, value: T? = nil) {
        self.queue = queue
        self.value = value
    }
    
    func get() -> T? {
        var value: T?
        queue.sync {
            value = self.value
        }
        return value
    }
    
    func set(_ value: T?) {
        queue.sync(flags: .barrier) {
            self.value = value
        }
    }
}
