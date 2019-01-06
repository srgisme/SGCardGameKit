import Foundation

enum CardGameError: Error, CustomStringConvertible {
    
    case notEnoughCards
    
    var description: String {
        switch self {
        case .notEnoughCards: return "Given the number of players and cards needed to play this game, there are not enough cards in the deck."
        }
    }
    
}

public protocol CardGameDelegate: AnyObject {
    
    func cardGameDidStart(_ cardGame: CardGame)
    func cardGameDidEnd(_ cardGame: CardGame)
    
}

public protocol CardGame: AnyObject {
    
    var deck: Stack<PlayingCard> { get set }
    var players: [CardPlayer] { get set }
    
}

extension Stack where T == PlayingCard {
    
    public init() {
        
        for suit in [PlayingCard.Suit.clubs, PlayingCard.Suit.diamonds, PlayingCard.Suit.hearts, PlayingCard.Suit.spades] {
            
            for j in 2 ... 14 {
                
                let card = PlayingCard(suit: suit, value: PlayingCard.Value(rawValue: j)!)
                self.push(card)
                
            }
            
        }
        
        self.shuffle()
        
    }
    
}
