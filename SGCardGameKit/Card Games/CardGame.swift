import Foundation

public protocol CardGame: AnyObject {
    
    var deck: Stack<PlayingCard> { get set }
    var players: [CardPlayer] { get set }
    
    func start() throws
    
}
