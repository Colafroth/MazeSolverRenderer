//
//  ThreadSafeArray.swift
//  MazeSolverRenderer
//
//  Created by AnTeng Lin on 3/9/18.
//  Copyright © 2018 Anteng Lin. All rights reserved.
//

import Foundation

class ThreadSafeArray<T> {
    private var array = [T]()
    private var queue = DispatchQueue(label: "com.array.tony", attributes: .concurrent)

    func append(_ object: T) {
        queue.async(flags: .barrier) {
            self.array.append(object)
        }
    }

    func contains(where predicate: (T) throws -> Bool) -> Bool {
        return queue.sync {
            try! array.contains(where: predicate)
        }
    }
}
