//
//  TexasHoldem.swift
//  OCCardGames
//
//  Created by Scott Gorden on 12/15/18.
//  Copyright © 2018 Orcacode. All rights reserved.
//

import Foundation

public enum Round {
    case preflop, flop, turn, river
}

public protocol TexasHoldemDelegate: CardGameDelegate {
    func texasHoldem(_ texasHoldem: TexasHoldem, didDeal round: Round)
}

public protocol TexasHoldem: CardGame {
    
    var dealerIndex: Int { get set }
    var blinds: (small: UInt, big: UInt) { get }
    var ante: UInt { get }
    var currentPots: (main: UInt, side: [UInt])? { get set }
    var community: [PlayingCard] { get set }
    var delegate: TexasHoldemDelegate? { get }
    
    func winners() -> [CardPlayer]
    func deal(_ round: Round) throws
    
}

extension TexasHoldem {
    
    public func deal(_ round: Round) throws {
        
        switch round {
            
        case .preflop:
            
            let numberOfCardsNeeded = 8 + 2 * self.players.count
            
            guard self.deck.count >= numberOfCardsNeeded else {
                let error = CardGameError.notEnoughCards
                print(error)
                throw error
            }
            
            for i in 0 ..< 2 * self.players.count {
                
                let player = self.players[(i + self.dealerIndex) % self.players.count]
                
                guard player.status == .inCurrentHand else {
                    continue
                }
                
                let newHoleCard = self.deck.pop()!
                player.holeCards.insert(newHoleCard)
                player.delegate?.cardPlayer(player, didReceive: newHoleCard)
                
            }
            
        case .flop:
            
            self.deck.pop()
            
            for _ in 0 ..< 3 {
                self.community.append(self.deck.pop()!)
            }
            
        case .turn, .river:
            
            self.deck.pop()
            self.community.append(self.deck.pop()!)
            
        }
        
        self.delegate?.texasHoldem(self, didDeal: round)
        
    }
    
    public func winners() -> [CardPlayer] {
        
        guard community.count == 5 else {
            return []
        }
        
        var winningPlayers: [TexasHoldemCardPlayer] = []
        
        (self.players as? [TexasHoldemCardPlayer])?.forEach { (player) in
            
            guard player.status == .inCurrentHand, let playerHandRank = player.hand() else {
                return
            }
            
            guard let currentWinningRank = winningPlayers.last?.hand() else {
                winningPlayers.append(player)
                return
            }
            
            if playerHandRank > currentWinningRank {
                
                winningPlayers = [player]
                
            } else if playerHandRank == currentWinningRank {
                
                winningPlayers.append(player)
                
            }
            
        }
        
        return winningPlayers
        
    }
    
}
