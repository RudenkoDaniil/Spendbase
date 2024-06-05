import Foundation

struct Card: Codable {
    let id: String
    let cardLast4: String
    let cardName: String
    let isLocked: Bool
    let isTerminated: Bool
    let spent: Int
    let limit: Int
    let limitType: String
    let cardHolder: CardHolder
    let fundingSource: String
    let issuedAt: String
}
