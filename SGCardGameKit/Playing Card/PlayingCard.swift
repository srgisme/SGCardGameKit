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
    
    public enum Suit {
        case clubs, diamonds, hearts, spades
    }
    
    public let suit: Suit
    public let value: Value
    
}

extension PlayingCard: CustomStringConvertible {
    
    public var description: String {
        return "\(value)\(suit)"
    }
    
}

extension PlayingCard: Comparable, Equatable {
    
    public static func < (lhs: PlayingCard, rhs: PlayingCard) -> Bool {
        return lhs.value < rhs.value
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

extension PlayingCard.Value: Comparable {
    
    public static func < (lhs: PlayingCard.Value, rhs: PlayingCard.Value) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
}

extension PlayingCard.Suit: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        case .clubs: return "♣︎"
        case .diamonds: return "♦︎"
        case .hearts: return "♥︎"
        case .spades: return "♠︎"
        }
        
    }
    
}
