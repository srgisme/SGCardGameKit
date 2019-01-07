//
//  TexasHoldemCardPlayer.swift
//  SGCardGameKit
//
//  Created by Scott Gorden on 1/7/19.
//  Copyright © 2019 Scott Gorden. All rights reserved.
//

import Foundation

public protocol TexasHoldemCardPlayer: CardPlayer {
    func hand() -> PokerHandRank?
}

extension TexasHoldemCardPlayer {
    
    public func hand() -> PokerHandRank? {
        return (holeCards + ((self.game as? TexasHoldem)?.community ?? [])).rank()
    }
    
}
