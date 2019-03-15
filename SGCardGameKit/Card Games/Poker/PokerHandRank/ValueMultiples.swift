//
//  ValueMultiples.swift
//  OCCardGames
//
//  Created by Scott Gorden on 12/18/18.
//  Copyright © 2018 Orcacode. All rights reserved.
//

import Foundation

extension Collection where Element == PlayingCard {
    
    /// This method produces the best 5-card poker hand limited to hands composed of only value multiples (pair, twoPair, threeOfaKind, fullHouse, fourOfaKind)
    ///
    /// - Returns: an optional PokerHandRank containing the hand rank and cards making up the hand. If no multiples are found, a hand containing multiples can not be made and this method returns nil.
    func handRankForValueMultiples() -> PokerHandRank? {
        
        guard self.count >= 5 else { return nil }
        
        let valueGroups = self.valueGroups()
        
        if let maxFourOfaKind = valueGroups[4]?.max(by: { $0[0].value < $1[0].value }) {
            
            let kickers = self.kickers(forIncompleteMultiples: maxFourOfaKind)
            return .fourOfaKind(maxFourOfaKind + kickers)
            
        }
        
        if var threeOfAKindsSorted = valueGroups[3]?.sorted(by: { $0[0].value < $1[0].value }), let pairs = valueGroups[2] {
            
            let maxThreeOfaKind = threeOfAKindsSorted.popLast()!
            let maxRemainingAsPair = (threeOfAKindsSorted + pairs).max { $0[0].value < $1[0].value }!
            return .fullHouse(maxThreeOfaKind + maxRemainingAsPair[0 ... 1])
            
        } else if var threeOfAKindsSorted = valueGroups[3]?.sorted(by: { $0[0].value < $1[0].value }) {
            
            let maxThreeOfaKind = threeOfAKindsSorted.popLast()!
            
            guard let maxRemainingAsPair = threeOfAKindsSorted.last else {
                
                let kickers = self.kickers(forIncompleteMultiples: maxThreeOfaKind)
                return .threeOfaKind(maxThreeOfaKind + kickers)
                
            }
            
            return .fullHouse(maxThreeOfaKind + maxRemainingAsPair[0 ... 1])
            
        } else if var pairsSorted = valueGroups[2]?.sorted(by: { $0[0].value < $1[0].value }) {
            
            let maxPair = pairsSorted.popLast()!
            
            guard let remainingPair = pairsSorted.popLast() else {
                
                let kickers = self.kickers(forIncompleteMultiples: maxPair)
                return .pair(maxPair + kickers)
                
            }
            
            let hand = maxPair + remainingPair
            let kickers = self.kickers(forIncompleteMultiples: hand)
            return .twoPair(hand + kickers)
            
        }
        
        return nil
        
    }
    
    // MARK: - Refactored Methods
    
    /// This method produces a Dictionary where the values are 2D arrays of cards. The elements of each value array is an array of cards with the same card value, and the keys are the number of occurrences of each value in each array.
    ///
    /// Example: if this method is called on [K♠︎, 5♣︎, 5♦︎, A♣︎, 4♥︎, A♦︎, K♥︎, K♣︎], the return value would be [1: [[4♥︎]], 2: [[A♣︎, A♦︎], [5♣︎, 5♦︎]], 3: [[K♠︎, K♥︎, K♣︎]]].
    private func valueGroups() -> [Int : [[PlayingCard]]] {
        
        let groupedByMultiples = Dictionary(grouping: self) { $0.value }.values
        return Dictionary(grouping: groupedByMultiples, by: { $0.count })
        
    }
    
    /// This method produces the right number of kickers (highest value cards used as the assisting cards for value multiple hands). If multiples.count < 0, this method produces a complete high card hand.
    /// - Parameters:
    ///     - multiples: an array consisting of only cards with the same value. This array can be empty.
    /// - Returns: an array of PlayingCard
    func kickers(forIncompleteMultiples multiples: [PlayingCard]) -> [PlayingCard] {
        
        guard multiples.count < 5 else {
            return []
        }
        
        let sortedCards = self.sorted(by: >)
        let valuesSet = Set(multiples.map({ $0.value }))
        
        var kickers: [PlayingCard] = []
        
        for card in sortedCards {
            
            guard !valuesSet.contains(card.value) else {
                continue
            }
            
            kickers.append(card)
            
            if kickers.count == 5 - multiples.count {
                break
            }
            
        }
        
        return kickers
        
    }
    
}
