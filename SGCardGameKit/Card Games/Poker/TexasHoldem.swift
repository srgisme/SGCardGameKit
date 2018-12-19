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
    
    init()
    init(players: [CardPlayer])
    
    var dealerIndex: Int { get set }
    var blinds: (small: UInt, big: UInt) { get }
    var ante: UInt { get }
    var currentPots: (main: UInt, side: [UInt]) { get set }
    var community: [PlayingCard] { get set }
    var delegate: TexasHoldemDelegate? { get }
    
    func winners() -> [CardPlayer]
    func deal(_ round: Round)
    
}

extension TexasHoldem {
    
    public init() {
        self.init(deck: Stack<PlayingCard>(), players: [])
        self.dealerIndex = 0
    }
    
    public init(players: [CardPlayer]) {
        self.init(deck: Stack<PlayingCard>(), players: players)
        self.dealerIndex = 0
    }
    
    private func dealToPlayers() throws {
        
        let numberOfCardsNeeded = 8 + 2 * self.players.count
        
        guard self.deck.count >= numberOfCardsNeeded else {
            throw CardGameError.notEnoughCards
        }
        
        for i in 0 ..< 2 * self.players.count {
            self.players[(i + self.dealerIndex) % self.players.count].holeCards.insert(self.deck.pop()!)
        }
        
    }
    
    func deal(_ round: Round) {
        
        switch round {
            
        case .preflop:
            
            do {
                try dealToPlayers()
                self.delegate?.cardGameDidStart(self)
            } catch let error {
                print(error)
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
        
        var winningPlayers: [CardPlayer] = []
        
        self.players.forEach { (player) in
            
            guard let playerHandRank = (player.holeCards + community).rank() else {
                return
            }
            
            guard let currentWinningRank = winningPlayers.last?.holeCards.rank() else {
                winningPlayers.append(player)
                return
            }
            
            if playerHandRank.rank.rawValue > currentWinningRank.rank.rawValue {
                winningPlayers = [player]
            } else if playerHandRank.rank.rawValue == currentWinningRank.rank.rawValue {
                
                for i in 0 ..< playerHandRank.cards.count {
                    
                    if playerHandRank.cards[i].value.rawValue > currentWinningRank.cards[i].value.rawValue {
                        winningPlayers = [player]
                        return
                    }
                    
                }
                
                winningPlayers.append(player)
                
            }
            
        }
        
        self.delegate?.cardGameDidEnd(self)
        return winningPlayers
        
    }
    
}
