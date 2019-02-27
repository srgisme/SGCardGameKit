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
    var burned: [PlayingCard] { get set }
    var players: [CardPlayer] { get }
}

enum TexasHoldemSetupError: Error, CustomStringConvertible {
    
    case notEnoughCards, notEnoughPlayers(Int), tooManyPlayers(Int)
    
    var description: String {
        switch self {
        case .notEnoughCards: return "Given the number of players and cards needed to play this game, there are not enough cards in the deck."
        case .notEnoughPlayers(let playerCount): return "There are not enough players in this game (\(playerCount)). You must have at least 2 players to begin the game."
        case .tooManyPlayers(let playerCount): return "There are too many players in this game (\(playerCount)). You must have 10 players or less to begin the game."
        }
    }
    
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
            player.holeCards.append(newHoleCard)
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
        self.burned.removeAll()
        
        self.players.forEach({ (player) in
            
            while let removedCard = player.holeCards.popLast() {
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
