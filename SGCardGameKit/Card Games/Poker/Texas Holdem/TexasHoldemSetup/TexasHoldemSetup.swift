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
    var setupDelegate: TexasHoldemSetupDelegate? { get }
    
    mutating func start() throws
    mutating func deal(_ round: Round)
    
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
    
    public mutating func start() throws {
        
        guard self.players.count >= 2 else {
            let error = TexasHoldemSetupError.notEnoughPlayers(self.players.count)
            print(error)
            throw error
        }
        
        guard self.players.count <= 10 else {
            let error = TexasHoldemSetupError.tooManyPlayers(self.players.count)
            print(error)
            throw error
        }
        
        self.dealerIndex = self.determineDealerIndex()
        self.setupDelegate?.texasHoldemSetup(self, dealerDidChange: self.players[self.dealerIndex] as! TexasHoldemCardPlayer)
        
        guard self.deck.count >= 8 + 2 * self.players.count else {
            let error = TexasHoldemSetupError.notEnoughCards
            print(error)
            throw error
        }
        
        self.deck = Stack<PlayingCard>()
        self.deck.shuffle()
        self.deal(.preflop)
        
    }
    
    public mutating func deal(_ round: Round) {
        
        switch round {
            
        case .preflop:
            
            for i in 0 ..< 2 * self.players.count {
                
                let player = self.players[(i + self.dealerIndex) % self.players.count]
                
                guard player.status == .inCurrentHand else {
                    continue
                }
                
                let newHoleCard = self.deck.pop()!
                player.holeCards.append(newHoleCard)
                player.delegate?.cardPlayer(player, didReceive: newHoleCard)
                
            }
            
        case .flop:
            
            self.burned.append(self.deck.pop()!)
            
            for _ in 0 ..< 3 {
                self.community.append(self.deck.pop()!)
            }
            
        case .turn, .river:
            
            self.burned.append(self.deck.pop()!)
            self.community.append(self.deck.pop()!)
            
        }
        
        self.setupDelegate?.texasHoldemSetup(self, didDeal: round)
        
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
