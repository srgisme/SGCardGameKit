//
//  CardGameDelegate.swift
//  SGCardGameKit
//
//  Created by Scott Gorden on 2/27/19.
//  Copyright © 2019 Scott Gorden. All rights reserved.
//

import Foundation

public protocol CardGameDelegate: AnyObject {
    
    func cardGameDidStart(_ cardGame: CardGame)
    func cardGameDidEnd(_ cardGame: CardGame)
    
}

extension CardGameDelegate {
    func cardGameDidStart(_ cardGame: CardGame) { }
    func cardGameDidEnd(_ cardGame: CardGame) { }
}
