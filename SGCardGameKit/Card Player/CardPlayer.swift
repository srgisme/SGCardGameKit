import Foundation

public enum CardPlayerHandStatus {
    case inCurrentHand, outOfCurrentHand, sittingOut
}

public protocol CardPlayer: AnyObject {
    
    var status: CardPlayerHandStatus { get set }
    var holeCards: Set<PlayingCard> { get set }
    
    func hand() -> PokerHandRank?
    
}
