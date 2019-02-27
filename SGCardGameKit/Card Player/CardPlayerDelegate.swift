//
//  CardPlayerDelegate.swift
//  SGCardGameKit
//
//  Created by Scott Gorden on 2/27/19.
//  Copyright © 2019 Scott Gorden. All rights reserved.
//

import Foundation

public protocol CardPlayerDelegate: AnyObject {
    func cardPlayer(_ cardPlayer: CardPlayer, didReceive card: PlayingCard)
    func cardPlayer(_ cardPlayer: CardPlayer, cardWasRemovedFromHoleCards card: PlayingCard)
}

extension CardPlayerDelegate {
    func cardPlayer(_ cardPlayer: CardPlayer, didReceive card: PlayingCard) { }
    func cardPlayer(_ cardPlayer: CardPlayer, cardWasRemovedFromHoleCards card: PlayingCard) { }
}
