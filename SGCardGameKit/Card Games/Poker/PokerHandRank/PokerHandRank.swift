//
//  PokerHandRank.swift
//  OCCardGames
//
//  Created by Scott Gorden on 12/15/18.
//  Copyright © 2018 Orcacode. All rights reserved.
//

import Foundation

public enum PokerHandRank {
    
    case highCard([PlayingCard])
    case pair([PlayingCard])
    case twoPair([PlayingCard])
    case threeOfaKind([PlayingCard])
    case straight([PlayingCard])
    case flush([PlayingCard])
    case fullHouse([PlayingCard])
    case fourOfaKind([PlayingCard])
    case straightFlush([PlayingCard])
    case royalFlush([PlayingCard])
    
}

extension PokerHandRank: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        case .highCard: return "High Card"
        case .pair: return "Pair"
        case .twoPair: return "Two Pair"
        case .threeOfaKind: return "Three of a Kind"
        case .straight: return "Straight"
        case .flush: return "Flush"
        case .fullHouse: return "Full House"
        case .fourOfaKind: return "Four of a Kind"
        case .straightFlush: return "Straight Flush"
        case .royalFlush: return "Royal Flush"
        }
        
    }
    
}

extension PokerHandRank: Comparable {
    
    var value: Int {
        
        switch self {
        case .highCard: return 1
        case .pair: return 2
        case .twoPair: return 3
        case .threeOfaKind: return 4
        case .straight: return 5
        case .flush: return 6
        case .fullHouse: return 7
        case .fourOfaKind: return 8
        case .straightFlush: return 9
        case .royalFlush: return 10
        }
        
    }
    
    var cards: [PlayingCard] {
        
        switch self {
        case .highCard(let cards): return cards
        case .pair(let cards): return cards
        case .twoPair(let cards): return cards
        case .threeOfaKind(let cards): return cards
        case .straight(let cards): return cards
        case .flush(let cards): return cards
        case .fullHouse(let cards): return cards
        case .fourOfaKind(let cards): return cards
        case .straightFlush(let cards): return cards
        case .royalFlush(let cards): return cards
        }
        
    }
    
    public static func < (lhs: PokerHandRank, rhs: PokerHandRank) -> Bool {
        
        guard lhs.value == rhs.value else {
            return lhs.value < rhs.value
        }
        
        let leftCards = lhs.cards
        let rightCards = rhs.cards
        
        guard leftCards.count == rightCards.count else {
            return false
        }
        
        for i in 0 ..< leftCards.count {
            
            if leftCards[i].value < rightCards[i].value {
                return true
            } else if leftCards[i].value > rightCards[i].value {
                return false
            }
            
        }
        
        return false
        
    }
    
    public static func == (lhs: PokerHandRank, rhs: PokerHandRank) -> Bool {
        
        guard lhs.value == rhs.value else {
            return false
        }
        
        return lhs.cards == rhs.cards
        
    }
    
}

extension Collection where Element == PlayingCard {
    
    /// This method produces the best 5-card poker hand from the given cards.
    /// - Important: This method may not produce the expected return value on collections with 10 or more elements.
    /// - Returns: an optional tuple containing the hand rank and cards making up the hand. If a 5-card hand can't be made, this method returns nil.
    func pokerHand() -> PokerHandRank? {
        
        guard self.count >= 5 else { return nil }
        
        let nonValueMultiples = self.handRankForNonValueMultiples()
        
        guard let valueMultiples = self.handRankForValueMultiples() else {
            return nonValueMultiples
        }
        
        return Swift.max(valueMultiples, nonValueMultiples)
        
    }
    
}
