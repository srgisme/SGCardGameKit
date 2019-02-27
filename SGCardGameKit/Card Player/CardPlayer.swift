import Foundation

public enum CardPlayerHandStatus {
    case inCurrentHand, outOfCurrentHand, sittingOut
}

public protocol CardPlayer: AnyObject {
    
    var status: CardPlayerHandStatus { get set }
    var game: CardGame? { get }
    var holeCards: [PlayingCard] { get set }
    var delegate: CardPlayerDelegate? { get }
    
}
