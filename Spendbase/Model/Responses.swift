import Foundation

struct BalanceResponse: Codable {
    let balance: Int
}

struct CardsResponse: Codable {
    let cards: [Card]
}

struct TransactionsResponse: Codable {
    let transactions: [Transaction]
}
