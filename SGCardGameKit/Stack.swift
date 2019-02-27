//
//  Stack.swift
//  OCCardGames
//
//  Created by Scott Gorden on 12/15/18.
//  Copyright © 2018 Orcacode. All rights reserved.
//

import Foundation

public struct Stack<T> {
    
    private var values: [T] = []
    
    public var count: Int {
        return self.values.count
    }
    
    public var isEmpty: Bool {
        return self.values.isEmpty
    }
    
    public init(capacity: Int) {
        self.values.reserveCapacity(capacity)
    }
    
    private init() { }
    
    public mutating func pop() -> T? {
        return self.values.popLast()
    }
    
    public mutating func push(_ element: T) {
        self.values.append(element)
    }
    
    public func peek() -> T? {
        return self.values.last
    }
    
    public mutating func removeAll() {
        self.values.removeAll()
    }
    
    public mutating func shuffle() {
        self.values.shuffle()
    }
    
}
