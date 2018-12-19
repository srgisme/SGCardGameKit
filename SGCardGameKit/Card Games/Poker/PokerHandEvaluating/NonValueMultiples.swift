//
//  NonValueMultiples.swift
//  OCCardGames
//
//  Created by Scott Gorden on 12/18/18.
//  Copyright © 2018 Orcacode. All rights reserved.
//

import Foundation

extension Collection where Element == PlayingCard {
    
    func handRankForNonValueMultiples() -> (rank: PokerHandRank, cards: [PlayingCard]) {
        
        if let royalFlush = self.cardsSatisfyingNonValueMultiples(for: .royalFlush)?.first {
            return (.royalFlush, royalFlush)
        } else if let straightFlush = self.cardsSatisfyingNonValueMultiples(for: .straightFlush)?.first {
            return (.straightFlush, Array(straightFlush[0 ..< 5]))
        } else if let flush = self.cardsSatisfyingNonValueMultiples(for: .flush)?.max(by: { (flush1, flush2) -> Bool in
            
            for i in 0 ..< Swift.min(flush1.count, flush2.count) {
                
                guard flush1[i].value != flush2[i].value else {
                    continue
                }
                
                return flush1[i].value.rawValue < flush2[i].value.rawValue
                
            }
            
            return true
            
        }) {
            
            return (.flush, Array(flush[0 ..< 5]))
            
        } else if var straight = self.cardsSatisfyingNonValueMultiples(for: .straight)?.first {
            straight.removeDuplicates()
            return (.straight, Array(straight[0 ..< 5]))
        } else {
            return (.highCard, self.kickers(forIncompleteMultiples: []))
        }
        
    }
    
    func cardsSatisfyingNonValueMultiples(for handRank: PokerHandRank) -> [[PlayingCard]]? {
        
        guard self.count >= 5 else {
            return nil
        }
        
        switch handRank {
        case .flush:
            
            var suitDict: [PlayingCard.Suit : [PlayingCard]] = [:]
            
            let sortedCards = self.sorted(by: >)
            
            sortedCards.forEach({ suitDict[$0.suit] = suitDict[$0.suit, default: []] + [$0] })
            
            let flushes = suitDict.values.filter({ $0.count >= 5 })
            
            return flushes
            
        case .straight:
            
            let sortedCards = self.sorted(by: >)
            
            var i = 0
            var j = 1
            var repeats = 0
            var straights: [[PlayingCard]] = []
            var aces: [PlayingCard] = []
            
            while j < sortedCards.count {
                
                if sortedCards[j].value == .ace {
                    aces.append(sortedCards[j])
                }
                
                let isPreviousValue = sortedCards[j].value == sortedCards[j - 1].value.previousValue()
                let isSameValue = sortedCards[j].value == sortedCards[j - 1].value
                
                if !(isPreviousValue || isSameValue) {
                    
                    if j - i - repeats >= 4 {
                        straights.append(Array(sortedCards[i ..< j]))
                    }
                    
                    i = j
                    repeats = 0
                    
                }
                
                if isSameValue {
                    repeats += 1
                }
                
                j += 1
                
            }
            
            if j - i - repeats >= 4 {
                straights.append(Array(sortedCards[i ..< j]))
            } else if j - i - repeats >= 3 && sortedCards[j - 1].value == .two && !aces.isEmpty {
                straights.append(Array(sortedCards[i ..< j]) + aces)
            }
            
            return straights.isEmpty ? nil : straights
            
        case .straightFlush:
            
            guard let straights = self.cardsSatisfyingNonValueMultiples(for: .straight), let flushes = self.cardsSatisfyingNonValueMultiples(for: .flush) else {
                return nil
            }
            // Js 10s 10h 9s 8s 7s 6s <- straight
            // As  Js 10s 9s 8s 7s 6s <- flush
            var straightFlushes: [[PlayingCard]] = []
            
            for flush in flushes {
                
                for straight in straights {
                    
                    var i = 0
                    var j = 0
                    var currentStraightFlush: [PlayingCard] = []
                    
                    while i < straight.count && j < flush.count {
                        
                        if straight[i].value.rawValue > flush[j].value.rawValue {
                            
                            if currentStraightFlush.count >= 5 && (currentStraightFlush.last?.value != straight[i].value) {
                                straightFlushes.append(currentStraightFlush)
                                currentStraightFlush = []
                            }
                            
                            i += 1
                            
                        } else if straight[i].value.rawValue < flush[j].value.rawValue {
                            
                            if currentStraightFlush.count >= 5 && (currentStraightFlush.last?.value != straight[i].value) {
                                straightFlushes.append(currentStraightFlush)
                                currentStraightFlush = []
                            }
                            
                            j += 1
                            
                        } else if straight[i].suit != flush[j].suit {
                            i += 1
                        } else {
                            
                            currentStraightFlush.append(straight[i])
                            i += 1
                            j += 1
                            
                        }
                        
                        
                        
                    }
                    
                    if currentStraightFlush.count >= 5 {
                        straightFlushes.append(currentStraightFlush)
                    }
                    
                }
                
            }
            
            return straightFlushes.isEmpty ? nil : straightFlushes
            
        case .royalFlush:
            
            guard let royalFlushes = self.cardsSatisfyingNonValueMultiples(for: .straightFlush)?.map({ $0[0 ..< 5] }).filter({ (straightFlush) -> Bool in
                straightFlush.map({ $0.value }) == [.ace, .king, .queen, .jack, .ten]
            }) else {
                return nil
            }
            
            return royalFlushes.isEmpty ? nil : royalFlushes.map({ Array($0) })
            
        default: return nil
            
        }
        
    }
    
}

extension Array where Element == PlayingCard {
    
    fileprivate mutating func removeDuplicates() {
        
        guard self.count > 1 else { return }
        
        var i = 1
        
        while i < self.count {
            
            guard self[i].value == self[i - 1].value else {
                i += 1
                continue
            }
            
            self.remove(at: i)
            
        }
        
    }
    
}
