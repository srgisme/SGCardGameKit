import Foundation

public protocol CardGameDelegate: AnyObject {
    
    func cardGameDidStart(_ cardGame: CardGame)
    func cardGameDidEnd(_ cardGame: CardGame)
    
}

public protocol CardGame: AnyObject {
    
    var deck: Stack<PlayingCard> { get set }
    var players: [CardPlayer] { get set }
    
    func start() throws
    
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
