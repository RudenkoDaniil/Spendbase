import Foundation
import UIKit
import RxSwift

final class DataService {
    static let shared = DataService()
    
    private init() {}
    
    static var balance: Double = 0 {
        didSet {
            balanceSubject.onNext(balance)
        }
    }
    
    static var cardData: [Card] = [] {
        didSet {
            cardDataSubject.onNext(cardData)
        }
    }
    
    static var transactionsData: [Transaction] = [] {
        didSet {
            transactionsDataSubject.onNext(transactionsData)
        }
    }
    
    static let balanceSubject = BehaviorSubject<Double>(value: balance)
    static let cardDataSubject = BehaviorSubject<[Card]>(value: cardData)
    static let transactionsDataSubject = BehaviorSubject<[Transaction]>(value: transactionsData)
    
    static func getBalance() -> Observable<Double> {
        return balanceSubject.asObservable()
    }
    
    static func getCardsData() -> Observable<[Card]> {
        return cardDataSubject.asObservable()
    }
    
    static func getTransactionsData() -> Observable<[Transaction]> {
        return transactionsDataSubject.asObservable()
    }
    
    static func loadCardsData(completion: @escaping (Bool) -> Void) {
        let teamId = "mockTeamId"
        
        let fetchCards = ApiService.shared.fetchCards(teamId: teamId)
        let fetchTransactions = ApiService.shared.fetchTransactions(teamId: teamId)
        let fetchBalance = ApiService.shared.fetchTotalBalance()
        
        Observable.zip(fetchCards, fetchTransactions, fetchBalance)
            .subscribe(onNext: { (cards, transactions, balance) in
                self.cardData = cards
                self.transactionsData = transactions
                self.balance = balance
                DispatchQueue.main.async {
                    completion(true)
                }
            }, onError: { error in
                print("Error loading data: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false)
                }
            })
            .disposed(by: (DisposeBag()))
    }
    
    static func loadRandomData(completion: @escaping (Bool) -> Void) {
        let randomCards = generateRandomCards(count: 5)
        let randomTransactions = generateRandomTransactions(count: 20)
        let randomBalance = generateRandomBalance()
        
        self.cardData = randomCards
        self.transactionsData = randomTransactions
        self.balance = randomBalance
        
        DispatchQueue.main.async {
            completion(true)
        }
    }
    
    private static func generateRandomCards(count: Int) -> [Card] {
        var cards = [Card]()
        for _ in 0..<count {
            let card = Card(
                id: UUID().uuidString,
                cardLast4: String(format: "%04d", Int.random(in: 1000..<10000)),
                cardName: "Card \(Int.random(in: 1..<100))",
                isLocked: Bool.random(),
                isTerminated: Bool.random(),
                spent: Int.random(in: 0..<5000),
                limit: Int.random(in: 5000..<10000),
                limitType: "Monthly",
                cardHolder: generateRandomCardHolder(),
                fundingSource: "Source \(Int.random(in: 1..<5))",
                issuedAt: generateRandomIssuedAt()
            )
            cards.append(card)
        }
        return cards
    }
    
    private static func generateRandomCardHolder() -> CardHolder {
        return CardHolder(
            id: UUID().uuidString,
            fullName: "Full Name \(Int.random(in: 1..<100))",
            email: "email\(Int.random(in: 1..<100))@example.com",
            logoUrl: "https://example.com/logo\(Int.random(in: 1..<10)).png"
        )
    }
    
    private static func generateRandomTransactions(count: Int) -> [Transaction] {
        var transactions = [Transaction]()
        for _ in 0..<count {
            let transaction = Transaction(
                id: UUID().uuidString,
                tribeTransactionId: UUID().uuidString,
                tribeCardId: Int.random(in: 1..<1000),
                amount: String(format: "%.2f", Double.random(in: 1..<1000)),
                status: generateRandomTransactionStatus(),
                tribeTransactionType: "Type \(Int.random(in: 1..<5))",
                schemeId: UUID().uuidString,
                merchantName: "Merchant \(Int.random(in: 1..<100))",
                pan: String(format: "%04d-%04d-%04d-%04d", Int.random(in: 1000..<10000), Int.random(in: 1000..<10000), Int.random(in: 1000..<10000), Int.random(in: 1000..<10000))
            )
            transactions.append(transaction)
        }
        return transactions
    }
    
    private static func generateRandomTransactionStatus() -> String {
        let statuses = ["load", "debit", "cancelled", "credit"]
        return statuses.randomElement() ?? "debit"
    }
    
    private static func generateRandomIssuedAt() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.string(from: Date().addingTimeInterval(-Double.random(in: 0..<31536000)))
    }
    
    private static func generateRandomBalance() -> Double {
        return Double.random(in: 1000..<10000)
    }
}
