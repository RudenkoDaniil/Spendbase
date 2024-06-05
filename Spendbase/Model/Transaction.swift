import Foundation

struct Transaction: Codable {
    let id: String
    let tribeTransactionId: String
    let tribeCardId: Int
    let amount: String
    let status: String
    let tribeTransactionType: String
    let schemeId: String
    let merchantName: String
    let pan: String
}

enum TransactionStatus {
    case load
    case debit
    case cancelled
    case credit
    init?(from string: String) {
        switch string.lowercased() {
        case "load":
            self = .load
        case "debit":
            self = .debit
        case "cancelled":
            self = .cancelled
        case "credit":
            self = .credit
        default:
            return nil
        }
    }
}
