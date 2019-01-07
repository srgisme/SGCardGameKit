//
//  TexasHoldemSetup.swift
//  SGCardGameKit
//
//  Created by Scott Gorden on 1/7/19.
//  Copyright © 2019 Scott Gorden. All rights reserved.
//

import Foundation

public protocol TexasHoldemSetup {
    var dealerIndex: Int { get set }
    var deck: Stack<PlayingCard> { get set }
    var community: [PlayingCard] { get set }
    var players: [CardPlayer] { get }
}

extension TexasHoldemSetup {
    
    func determineDealerIndex() -> Int {
        
        var dealerCards = Array(0 ..< self.players.count)
        
        var currentDealerIndex: Int = 0
        
        self.players.enumerated().forEach { (i, player) in
            
            guard player.status != .sittingOut else {
                return
            }
            
            guard let cardValueIndex = dealerCards.randomElement() else {
                return
            }
            
            let newHoleCard = PlayingCard(suit: .spades, value: PlayingCard.Value(rawValue: dealerCards.remove(at: cardValueIndex) + 2)!)
            player.holeCards.insert(newHoleCard)
            player.delegate?.cardPlayer(player, didReceive: newHoleCard)
            
            guard let highestCardValue = self.players[currentDealerIndex].holeCards.first?.value.rawValue else {
                currentDealerIndex = i
                return
            }
            
            if newHoleCard.value.rawValue > highestCardValue {
                currentDealerIndex = i
            }
            
        }
        
        return currentDealerIndex
        
    }
    
    mutating func resetForNextHand() {
        
        self.deck = Stack<PlayingCard>()
        self.community.removeAll()
        
        self.players.forEach({ (player) in
            
            while let removedCard = player.holeCards.popFirst() {
                player.delegate?.cardPlayer(player, cardWasRemovedFromHoleCards: removedCard)
            }
            
        })
        
        var nextPlayerIndex = (self.players.count + 1) % self.players.count
        
        while self.players[nextPlayerIndex].status != .sittingOut {
            
            nextPlayerIndex = (nextPlayerIndex + 1) % self.players.count
            
        }
        
        self.dealerIndex = nextPlayerIndex
        
    }
    
}
