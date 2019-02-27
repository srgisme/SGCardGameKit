//
//  TexasHoldemDelegate.swift
//  SGCardGameKit
//
//  Created by Scott Gorden on 2/27/19.
//  Copyright © 2019 Scott Gorden. All rights reserved.
//

import Foundation

public protocol TexasHoldemDelegate: CardGameDelegate {
    func texasHoldem(_ texasHoldem: TexasHoldem, dealerIndexDidChange dealerIndex: Int)
    func texasHoldem(_ texasHoldem: TexasHoldem, didDeal round: Round)
}

extension TexasHoldemDelegate {
    func texasHoldem(_ texasHoldem: TexasHoldem, dealerIndexDidChange dealerIndex: Int) { }
    func texasHoldem(_ texasHoldem: TexasHoldem, didDeal round: Round) { }
}
