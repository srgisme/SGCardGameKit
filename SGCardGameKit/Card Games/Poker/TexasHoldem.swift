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

enum TexasHoldemCardGameError: Error, CustomStringConvertible {
    
    case notEnoughCards, notEnoughPlayers(Int), tooManyPlayers(Int)
    
    var description: String {
        switch self {
        case .notEnoughCards: return "Given the number of players and cards needed to play this game, there are not enough cards in the deck."
        case .notEnoughPlayers(let playerCount): return "There are not enough players in this game (\(playerCount)). You must have at least 2 players to begin the game."
        case .tooManyPlayers(let playerCount): return "There are too many players in this game (\(playerCount)). You must have 10 players or less to begin the game."
        }
    }
    
}

public protocol TexasHoldemDelegate: CardGameDelegate {
    func texasHoldem(_ texasHoldem: TexasHoldem, dealerIndexDidChange dealerIndex: Int)
    func texasHoldem(_ texasHoldem: TexasHoldem, didDeal round: Round)
}

public protocol TexasHoldem: CardGame, TexasHoldemSetup {
    
    var dealerIndex: Int { get set }
    var blinds: (small: UInt, big: UInt) { get }
    var ante: UInt { get }
    var currentPots: (main: UInt, side: [UInt])? { get set }
    var community: [PlayingCard] { get set }
    var delegate: TexasHoldemDelegate? { get }
    
    func winners() -> [TexasHoldemCardPlayer]
    func deal(_ round: Round)
    
}

extension TexasHoldem {
    
    public func start() throws {
        
        guard self.players.count >= 2 else {
            let error = TexasHoldemCardGameError.notEnoughPlayers(self.players.count)
            print(error)
            throw error
        }
        
        guard self.players.count <= 10 else {
            let error = TexasHoldemCardGameError.tooManyPlayers(self.players.count)
            print(error)
            throw error
        }
        
        self.dealerIndex = self.determineDealerIndex()
        
        guard self.deck.count >= 8 + 2 * self.players.count else {
            let error = TexasHoldemCardGameError.notEnoughCards
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
