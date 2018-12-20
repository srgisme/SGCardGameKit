import Foundation

public enum PlayerStatus {
    case inCurrentHand, outOfCurrentHand
}

public protocol CardPlayer: AnyObject {
    
    var status: PlayerStatus { get set }
    var holeCards: Set<PlayingCard> { get set }
    
    func hand() -> (rank: PokerHandRank, cards: [PlayingCard])?
    
}
