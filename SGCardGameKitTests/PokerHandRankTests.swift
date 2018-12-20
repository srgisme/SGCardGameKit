//
//  PokerHandRankTests.swift
//  SGCardGameKitTests
//
//  Created by Scott Gorden on 12/19/18.
//  Copyright © 2018 Scott Gorden. All rights reserved.
//

import XCTest
@testable import SGCardGameKit

class PokerHandRankTests: XCTestCase {

    var cards: [PlayingCard] = []
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        cards = []
    }
    
    func testHighCard() {
        self.test(rank: .highCard)
    }
    
    func testPair() {
        self.test(rank: .pair)
    }
    
    func testTwoPair() {
        self.test(rank: .twoPair)
    }
    
    func testThreeOfaKind() {
        self.test(rank: .threeOfaKind)
    }
    
    func testStraight() {
        self.test(rank: .straight)
    }
    
    func testFlush() {
        self.test(rank: .flush)
    }
    
    func testFullHouse() {
        self.test(rank: .fullHouse)
    }
    
    func testFourOfaKind() {
        self.test(rank: .fourOfaKind)
    }
    
    func testStraightFlush() {
        self.test(rank: .straightFlush)
    }
    
    func testRoyalFlush() {
        self.test(rank: .royalFlush)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

extension PokerHandRankTests {
    
    private func test(rank: PokerHandRank) {
        
        switch rank {
        case .highCard:
            
            cards = [PlayingCard(suit: .spades, value: .ten),
                     PlayingCard(suit: .hearts, value: .five),
                     PlayingCard(suit: .clubs, value: .ace),
                     PlayingCard(suit: .diamonds, value: .four),
                     PlayingCard(suit: .spades, value: .three),
                     PlayingCard(suit: .hearts, value: .queen),
                     PlayingCard(suit: .spades, value: .king)]
            
        case .pair:
            
            cards = [PlayingCard(suit: .spades, value: .ten),
                     PlayingCard(suit: .hearts, value: .ten),
                     PlayingCard(suit: .clubs, value: .ace),
                     PlayingCard(suit: .diamonds, value: .four),
                     PlayingCard(suit: .spades, value: .three),
                     PlayingCard(suit: .hearts, value: .queen),
                     PlayingCard(suit: .spades, value: .king)]
            
        case .twoPair:
            
            cards = [PlayingCard(suit: .spades, value: .ten),
                     PlayingCard(suit: .hearts, value: .ten),
                     PlayingCard(suit: .clubs, value: .ace),
                     PlayingCard(suit: .diamonds, value: .four),
                     PlayingCard(suit: .spades, value: .three),
                     PlayingCard(suit: .hearts, value: .queen),
                     PlayingCard(suit: .spades, value: .four)]
            
        case .threeOfaKind:
            
            cards = [PlayingCard(suit: .spades, value: .ten),
                     PlayingCard(suit: .clubs, value: .ace),
                     PlayingCard(suit: .diamonds, value: .four),
                     PlayingCard(suit: .hearts, value: .ten),
                     PlayingCard(suit: .spades, value: .three),
                     PlayingCard(suit: .diamonds, value: .ten),
                     PlayingCard(suit: .spades, value: .nine)]
            
        case .straight:
            
            cards = [PlayingCard(suit: .spades, value: .ten),
                     PlayingCard(suit: .clubs, value: .six),
                     PlayingCard(suit: .diamonds, value: .seven),
                     PlayingCard(suit: .hearts, value: .ten),
                     PlayingCard(suit: .spades, value: .eight),
                     PlayingCard(suit: .diamonds, value: .ten),
                     PlayingCard(suit: .spades, value: .nine)]
            
        case .flush:
            
            cards = [PlayingCard(suit: .spades, value: .ten),
                     PlayingCard(suit: .spades, value: .six),
                     PlayingCard(suit: .diamonds, value: .seven),
                     PlayingCard(suit: .hearts, value: .seven),
                     PlayingCard(suit: .spades, value: .eight),
                     PlayingCard(suit: .spades, value: .seven),
                     PlayingCard(suit: .spades, value: .king)]
            
        case .fullHouse:
            
            cards = [PlayingCard(suit: .spades, value: .ten),
                     PlayingCard(suit: .hearts, value: .ten),
                     PlayingCard(suit: .clubs, value: .ace),
                     PlayingCard(suit: .diamonds, value: .four),
                     PlayingCard(suit: .spades, value: .ace),
                     PlayingCard(suit: .clubs, value: .ten),
                     PlayingCard(suit: .spades, value: .four)]
            
        case .fourOfaKind:
            
            cards = [PlayingCard(suit: .spades, value: .ten),
                     PlayingCard(suit: .hearts, value: .ten),
                     PlayingCard(suit: .clubs, value: .ace),
                     PlayingCard(suit: .diamonds, value: .four),
                     PlayingCard(suit: .spades, value: .ace),
                     PlayingCard(suit: .clubs, value: .ten),
                     PlayingCard(suit: .diamonds, value: .ten)]
            
        case .straightFlush:
            
            cards = [PlayingCard(suit: .spades, value: .ten),
                     PlayingCard(suit: .spades, value: .six),
                     PlayingCard(suit: .spades, value: .seven),
                     PlayingCard(suit: .spades, value: .jack),
                     PlayingCard(suit: .spades, value: .eight),
                     PlayingCard(suit: .diamonds, value: .ten),
                     PlayingCard(suit: .spades, value: .nine)]
            
        case .royalFlush:
            
            cards = [PlayingCard(suit: .spades, value: .ten),
                     PlayingCard(suit: .spades, value: .king),
                     PlayingCard(suit: .spades, value: .queen),
                     PlayingCard(suit: .spades, value: .jack),
                     PlayingCard(suit: .spades, value: .nine),
                     PlayingCard(suit: .diamonds, value: .ten),
                     PlayingCard(suit: .spades, value: .ace)]
            
        }
        
        let handRank = self.cards.rank()!
        print(handRank.cards)
        XCTAssert(handRank.rank == rank, "rank should be \(rank) but was instead \(handRank.rank)")
        
    }
    
}
