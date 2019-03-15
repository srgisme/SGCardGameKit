import Foundation

public struct PlayingCard: Hashable {
    
    public enum Value: Int {
        
        case two = 2, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace
        
        public func nextValue() -> Value {
            
            guard self == .ace else {
                return Value(rawValue: self.rawValue + 1)!
            }
            
            return .two
            
        }
        
        public func previousValue() -> Value {
            
            guard self == .two else {
                return Value(rawValue: self.rawValue - 1)!
            }
            
            return .ace
            
        }
        
    }
    
    public enum Suit: String {
        case clubs = "♣︎"
        case diamonds = "♦︎"
        case hearts = "♥︎"
        case spades = "♠︎"
    }
    
    public let suit: Suit
    public let value: Value
    
}

extension PlayingCard: CustomStringConvertible {
    
    public var description: String {
        return "\(value)\(suit.rawValue)"
    }
    
}

extension PlayingCard: Comparable, Equatable {
    
    public static func < (lhs: PlayingCard, rhs: PlayingCard) -> Bool {
        return lhs.value.rawValue < rhs.value.rawValue
    }
    
    public static func == (lhs: PlayingCard, rhs: PlayingCard) -> Bool {
        return lhs.value == rhs.value && lhs.suit == rhs.suit
    }
    
}

extension PlayingCard.Value: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        case .jack: return "J"
        case .queen: return "Q"
        case .king: return "K"
        case .ace: return "A"
        default: return "\(self.rawValue)"
        }
        
    }
    
}

extension Stack where T == PlayingCard {
    
    public init() {
        
        self.init(capacity: 52)
        
        for suit in [PlayingCard.Suit.clubs, PlayingCard.Suit.diamonds, PlayingCard.Suit.hearts, PlayingCard.Suit.spades] {
            
            for j in 2 ... 14 {
                
                let card = PlayingCard(suit: suit, value: PlayingCard.Value(rawValue: j)!)
                self.push(card)
                
            }
            
        }
        
        self.shuffle()
        
    }
    
}
