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
    /// - Returns: an optional tuple containing the hand rank and cards making up the hand. If no multiples are found, this method returns nil.
    func handRankForValueMultiples() -> (rank: PokerHandRank, cards: [PlayingCard])? {
        
        guard self.count >= 5 else { return nil }
        
        let valueGroups = self.valueGroups()
        
        if let maxFourOfaKind = valueGroups[4]?.first {
            
            let kickers = self.kickers(forIncompleteMultiples: maxFourOfaKind)
            return (.fourOfaKind, maxFourOfaKind + kickers)
            
        } else if let threeOfAKind = valueGroups[3] {
            
            let maxThreeOfaKind = threeOfAKind[0]
            
            let hand: [PlayingCard] = maxThreeOfaKind
            
            var maxPair: [PlayingCard] = []
            
            for multiples in (threeOfAKind + (valueGroups[2] ?? [])) {
                
                guard multiples[0].value != maxThreeOfaKind[0].value else {
                    continue
                }
                
                guard !maxPair.isEmpty else {
                    maxPair = [multiples[0], multiples[1]]
                    continue
                }
                
                if multiples[0].value.rawValue > maxPair[0].value.rawValue {
                    maxPair = [multiples[0], multiples[1]]
                }
                
            }
            
            guard !maxPair.isEmpty else {
                
                let kickers = self.kickers(forIncompleteMultiples: hand)
                return (.threeOfaKind, hand + kickers)
                
            }
            
            return (.fullHouse, hand + maxPair)
            
        } else if let pairs = valueGroups[2] {
            
            if pairs.count > 1 {
                
                let hand = pairs[0] + pairs[1]
                let kickers = self.kickers(forIncompleteMultiples: hand)
                return (.twoPair, hand + kickers)
                
            } else {
                
                let kickers = self.kickers(forIncompleteMultiples: pairs[0])
                return (.pair, pairs[0] + kickers)
                
            }
            
        }
        
        return nil
        
    }
    
    // MARK: - Refactored Methods
    
    /// This method produces a Dictionary where the values are all arrays of cards containing at least another with the same card value, and the keys are the number of occurrences of each value in each array. Values with no multiples (counts of only 1) are ommitted from this dictionary.
    ///
    /// Example: if this method is called on [K♠︎, 5♣︎, 5♦︎, A♣︎, A♦︎, K♥︎, K♣︎], the return value would be [2: [[A♣︎, A♦︎], [5♣︎, 5♦︎]], 3: [[K♠︎, K♥︎, K♣︎]]].
    private func valueGroups() -> [Int : [[PlayingCard]]] {
        
        let sortedCards = self.sorted(by: >)
        
        var valueGroups: [Int : [[PlayingCard]]] = [:]
        
        var currentCards: [PlayingCard] = []
        
        for card in sortedCards {
            
            guard let currentValue = currentCards.last?.value else {
                currentCards.append(card)
                continue
            }
            
            if card.value == currentValue {
                currentCards.append(card)
            } else if currentCards.count > 1 {
                valueGroups[currentCards.count] = valueGroups[currentCards.count, default: []] + [currentCards]
                currentCards = [card]
            } else {
                currentCards = [card]
            }
            
        }
        
        if currentCards.count > 1 {
            
            valueGroups[currentCards.count] = valueGroups[currentCards.count, default: []] + [currentCards]
            currentCards = []
            
        }
        
        return valueGroups
        
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
