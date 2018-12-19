import Foundation

public struct PlayingCard: CustomStringConvertible, Hashable {
    
    public enum Value: Int, CustomStringConvertible {
        
        case two = 2, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace
        
        public var description: String {
            
            switch self {
            case .jack: return "J"
            case .queen: return "Q"
            case .king: return "K"
            case .ace: return "A"
            default: return "\(self.rawValue)"
            }
            
        }
        
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
