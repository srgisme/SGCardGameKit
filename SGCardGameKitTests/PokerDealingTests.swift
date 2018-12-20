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

    class TexasHoldemPokerGame: TexasHoldem {
        
        var dealerIndex: Int = 0
        var blinds: (small: UInt, big: UInt) = (1, 2)
        var ante: UInt = 0
        var currentPots: (main: UInt, side: [UInt])?
        var players: [CardPlayer] = []
        
        var deck: Stack<PlayingCard> = Stack<PlayingCard>()
        var community: [PlayingCard] = []
        
        var delegate: TexasHoldemDelegate?
        
    }
    
    class TexasHoldemPlayer: CardPlayer {
        
        var status: PlayerStatus
        var holeCards: Set<PlayingCard> = []
        weak var game: CardGame?
        
        init() {
            self.status = .inCurrentHand
        }
        
        func hand() -> (rank: PokerHandRank, cards: [PlayingCard])? {
            return (holeCards + ((self.game as? TexasHoldem)?.community ?? [])).rank()
        }
        
    }
    
    var game: TexasHoldemPokerGame = TexasHoldemPokerGame()
    
    override func setUp() {
        
        for _ in 0 ..< 9 {
            
            let player = TexasHoldemPlayer()
            player.game = self.game
            self.game.players.append(player)
            
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
        print("Winners: \(winners.map({ $0.holeCards }))")
        
    }
    
    override func tearDown() {
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

extension PokerDealingTests {
    
    func testDeal(_ round: Round) {
        
        switch round {
        case .preflop:
            
            do {
                try self.game.deal(round)
                
                let allPlayersHaveTwoCards = self.game.players.reduce(into: true) { (playersHaveTwoCards, currentPlayer) in
                    
                    guard playersHaveTwoCards else {
                        playersHaveTwoCards = false
                        return
                    }
                    
                    playersHaveTwoCards = currentPlayer.holeCards.count == 2
                    
                }
                
                XCTAssert(allPlayersHaveTwoCards, "Players do not have two cards after dealing the cards preflop")
                XCTAssert(self.game.community.isEmpty, "Community is not empty after dealing preflop.")
            } catch let error {
                XCTFail("\(error)")
            }
            
        case .flop:
            
            do {
                
                try self.game.deal(round)
                
                XCTAssert(self.game.community.count == 3, "Community doesn't have 3 cards after dealing the flop.")
                
            } catch let error {
                XCTFail("\(error)")
            }
            
        case .turn:
            
            do {
                try self.game.deal(round)
                XCTAssert(self.game.community.count == 4, "Community doesn't have 4 cards after dealing the turn")
            } catch let error {
                XCTFail("\(error)")
            }
            
        case .river:
            
            do {
                try self.game.deal(round)
                XCTAssert(self.game.community.count == 5, "Community doesn't have 5 cards after dealing the river.")
            } catch let error {
                XCTFail("\(error)")
            }
            
        }
        
    }
    
}
