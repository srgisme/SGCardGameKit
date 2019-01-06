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
    
    public init(elements: [T]) {
        
        guard let firstElement = elements.first else {
            self.values = []
            return
        }
        
        self.push(firstElement)
        
        for i in 1 ..< elements.count {
            self.push(elements[i])
        }
        
    }
    
    public var isEmpty: Bool {
        return self.values.isEmpty
    }
    
    public mutating func pop() -> T? {
        return self.values.popLast()
    }
    
    public mutating func push(_ element: T) {
        self.values.append(element)
    }
    
    public func peek() -> T? {
        return self.values.last
    }
    
}

extension Stack where T == PlayingCard {
    
    public mutating func shuffle() {
        self.values.shuffle()
    }
    
}
