//
//  ThreadSafeStack.swift
//  MazeSolverRenderer
//
//  Created by AnTeng Lin on 3/9/18.
//  Copyright © 2018 Anteng Lin. All rights reserved.
//

import Foundation

class ThreadSafeStack<T> {
     var array = [T]()
    private var queue = DispatchQueue(label: "com.stack.tony", attributes: .concurrent)

    func push(_ object: T) {
        queue.async(flags: .barrier) {
            self.array.append(object)
        }
    }

    func pop() -> T? {
        return queue.sync(flags: .barrier) {
            array.popLast()
        }
    }
    
    func removeAll() {
        queue.sync(flags: .barrier) {
            array.removeAll()
        }
    }
}
