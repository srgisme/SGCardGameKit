//
//  PokerHandEvaluating.swift
//  OCCardGames
//
//  Created by Scott Gorden on 12/15/18.
//  Copyright © 2018 Orcacode. All rights reserved.
//

import Foundation

public enum PokerHandRank: Int, CustomStringConvertible {
    
    case highCard = 1, pair, twoPair, threeOfaKind, straight, flush, fullHouse, fourOfaKind, straightFlush, royalFlush
    
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

protocol PokerHandEvaluating {
    
    func playingCardsForEvaluating(_ playingCards: Set<PlayingCard>)
    func evaluateHand(_ hand: Set<PlayingCard>) -> PokerHandRank
    
}

extension Collection where Element == PlayingCard {
    
    /// This method produces the best 5-card poker hand from the given cards.
    /// - Important: This method may not produce the expected return value on collections with 10 or more elements.
    /// - Returns: an optional tuple containing the hand rank and cards making up the hand. If a 5-card hand can't be made, this method returns nil.
    public func rank() -> (rank: PokerHandRank, cards: [PlayingCard])? {
        
        guard self.count >= 5 else { return nil }
        
        let nonValueMultiples = self.handRankForNonValueMultiples()
        
        guard let valueMultiples = self.handRankForValueMultiples() else {
            return nonValueMultiples
        }
        
        return valueMultiples.rank.rawValue > nonValueMultiples.rank.rawValue ? valueMultiples : nonValueMultiples
        
    }
    
}
