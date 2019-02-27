//
//  PokerDealingTests.swift
//  SGCardGameKitTests
//
//  Created by Scott Gorden on 12/19/18.
//  Copyright © 2018 Scott Gorden. All rights reserved.
//

import XCTest
@testable import SGCardGameKit

class PokerDealingTests: XCTestCase {

    class TexasHoldemPokerGame: TexasHoldem, CardPlayerDelegate {
        
        var dealerIndex: Int = 0
        var blinds: (small: UInt, big: UInt) = (1, 2)
        var ante: UInt = 0
        var currentPots: (main: UInt, side: [UInt])?
        var players: [CardPlayer] = []
        
        var deck: Stack<PlayingCard> = Stack<PlayingCard>()
        var community: [PlayingCard] = []
        var burned: [PlayingCard] = []
        
        weak var delegate: TexasHoldemDelegate?
        weak var setupDelegate: TexasHoldemSetupDelegate?
        
    }
    
    class TexasHoldemPlayer: TexasHoldemCardPlayer {
        
        var status: CardPlayerHandStatus
        var holeCards: [PlayingCard] = []
        
        weak var delegate: CardPlayerDelegate?
        weak var game: CardGame?
        
        init() {
            self.status = .inCurrentHand
        }
        
    }
    
    var game: TexasHoldemPokerGame = TexasHoldemPokerGame()
    
    override func setUp() {
        
        for _ in 0 ..< 9 {
            
            let player = TexasHoldemPlayer()
            player.status = Int.random(in: 0 ... 1) == 0 ? .inCurrentHand : .outOfCurrentHand
            
            self.game.players.append(player)
            player.game = self.game
            player.delegate = self.game
            
        }
        
    }
    
    func testGameMechanics() {
        
        self.testDeal(.preflop)
        self.testDeal(.flop)
        self.testDeal(.turn)
        self.testDeal(.river)
        
        let winners = self.game.winners() 
        
        print("Players: \(self.game.players.map({ $0.holeCards }))")
        print("Community: \(self.game.community)")
        print("Winners: \(winners.map({ $0.holeCards })), \(winners.map({ $0.hand()!.description }))")
        
    }
    
    override func tearDown() {
        
    }

}

extension PokerDealingTests {
    
    func testDeal(_ round: Round) {
        
        switch round {
        case .preflop:
            
            do {
                try self.game.deal(round)
                
                var allPlayersHaveCorrectNumberOfCards = true
                
                for player in self.game.players {
                    
                    guard allPlayersHaveCorrectNumberOfCards else {
                        break
                    }
                    
                    allPlayersHaveCorrectNumberOfCards = player.status == .inCurrentHand ? player.holeCards.count == 2 : player.holeCards.count == 0
                    
                }
                
                XCTAssert(allPlayersHaveCorrectNumberOfCards, "Players do not have the correct number of cards after dealing the cards preflop.")
                XCTAssert(self.game.community.isEmpty, "Community is not empty after dealing preflop.")
            } catch let error {
                XCTFail("\(error)")
            }
            
        case .flop:
            
            do {
                
                try self.game.deal(round)
                
                XCTAssert(self.game.community.count == 3, "Community doesn't have 3 cards after dealing the flop.")
                XCTAssert(self.game.burned.count == 1)
            } catch let error {
                XCTFail("\(error)")
            }
            
        case .turn:
            
            do {
                try self.game.deal(round)
                XCTAssert(self.game.community.count == 4, "Community doesn't have 4 cards after dealing the turn")
                XCTAssert(self.game.burned.count == 2)
            } catch let error {
                XCTFail("\(error)")
            }
            
        case .river:
            
            do {
                try self.game.deal(round)
                XCTAssert(self.game.community.count == 5, "Community doesn't have 5 cards after dealing the river.")
                XCTAssert(self.game.burned.count == 3)
            } catch let error {
                XCTFail("\(error)")
            }
            
        }
        
    }
    
}
