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
    
    var blinds: (small: UInt, big: UInt) { get }
    var ante: UInt { get }
    var currentPots: (main: UInt, side: [UInt])? { get set }
    var delegate: TexasHoldemDelegate? { get }
    
    func winners() -> [TexasHoldemCardPlayer]
    
}

extension TexasHoldem {
    
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
