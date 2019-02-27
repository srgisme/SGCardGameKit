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

public protocol TexasHoldem: CardGame, TexasHoldemSetup {
    
    var dealerIndex: Int { get set }
    var blinds: (small: UInt, big: UInt) { get }
    var ante: UInt { get }
    var currentPots: (main: UInt, side: [UInt])? { get set }
    var community: [PlayingCard] { get set }
    var burned: [PlayingCard] { get set }
    var delegate: TexasHoldemDelegate? { get }
    
    func winners() -> [TexasHoldemCardPlayer]
    func deal(_ round: Round)
    
}

extension TexasHoldem {
    
    public func start() throws {
        
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
        
        guard self.deck.count >= 8 + 2 * self.players.count else {
            let error = TexasHoldemSetupError.notEnoughCards
            print(error)
            throw error
        }
        
        self.deck = Stack<PlayingCard>()
        self.deck.shuffle()
        
        self.deal(.preflop)
        
    }
    
    public func deal(_ round: Round) {
        
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
        
        self.delegate?.texasHoldem(self, didDeal: round)
        
    }
    
    public func winners() -> [TexasHoldemCardPlayer] {
        
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
