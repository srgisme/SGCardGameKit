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

extension Stack where T == PlayingCard {
    
    public init() {
        
        self.init(capacity: 52)
        
        for suit in [PlayingCard.Suit.clubs, PlayingCard.Suit.diamonds, PlayingCard.Suit.hearts, PlayingCard.Suit.spades] {
            
            for j in 2 ... 14 {
                
                let card = PlayingCard(suit: suit, value: PlayingCard.Value(rawValue: j)!)
                self.push(card)
                
            }
            
        }
        
        self.shuffle()
        
    }
    
}
