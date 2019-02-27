//
//  TexasHoldemSetupDelegate.swift
//  SGCardGameKit
//
//  Created by Scott Gorden on 2/27/19.
//  Copyright © 2019 Scott Gorden. All rights reserved.
//

import Foundation

public protocol TexasHoldemSetupDelegate: AnyObject {
    func texasHoldemSetup(_ texasHoldemSetup: TexasHoldemSetup, dealerDidChange dealer: TexasHoldemCardPlayer)
    func texasHoldemSetup(_ texasHoldemSetup: TexasHoldemSetup, didDeal round: Round)
}

extension TexasHoldemSetupDelegate {
    func texasHoldemSetup(_ texasHoldemSetup: TexasHoldemSetup, dealerIndexDidChange dealerIndex: Int) { }
    func texasHoldemSetup(_ texasHoldemSetup: TexasHoldemSetup, didDeal round: Round) { }
}
