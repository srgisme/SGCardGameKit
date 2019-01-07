import Foundation

public enum CardPlayerHandStatus {
    case inCurrentHand, outOfCurrentHand, sittingOut
}

public protocol CardPlayerDelegate: AnyObject {
    func cardPlayer(_ cardPlayer: CardPlayer, didReceive card: PlayingCard)
    func cardPlayer(_ cardPlayer: CardPlayer, cardWasRemovedFromHoleCards card: PlayingCard)
}

public protocol CardPlayer: AnyObject {
    
    var status: CardPlayerHandStatus { get set }
    var game: CardGame? { get }
    var holeCards: Set<PlayingCard> { get set }
    var delegate: CardPlayerDelegate? { get }
    
}
