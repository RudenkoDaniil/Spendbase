import Foundation
import RxSwift
import RxCocoa

class ApiService {
    static let shared = ApiService()
    
    private init() {}

    private let baseURL = "https://api.example.com"  

    func fetchTotalBalance() -> Observable<Double> {
        let url = URL(string: "\(baseURL)/cards/account/total-balance")!
        return URLSession.shared.rx.data(request: URLRequest(url: url))
            .map { data in
                let decoder = JSONDecoder()
                let response = try decoder.decode(BalanceResponse.self, from: data)
                return Double(response.balance)
            }
            .catch { error in
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
            }
    }
    func fetchCards(teamId: String) -> Observable<[Card]> {
        var components = URLComponents(string: "\(baseURL)/cards")!
        components.queryItems = [URLQueryItem(name: "teamId", value: teamId)]
        let url = components.url!
        
        return URLSession.shared.rx.data(request: URLRequest(url: url))
            .map { data in
                let decoder = JSONDecoder()
                let response = try decoder.decode(CardsResponse.self, from: data)
                return response.cards
            }
            .catch { error in
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
            }
    }
    func fetchTransactions(teamId: String) -> Observable<[Transaction]> {
        var components = URLComponents(string: "\(baseURL)/cards/transactions")!
        components.queryItems = [URLQueryItem(name: "teamId", value: teamId)]
        let url = components.url!
        
        return URLSession.shared.rx.data(request: URLRequest(url: url))
            .map { data in
                let decoder = JSONDecoder()
                let response = try decoder.decode(TransactionsResponse.self, from: data)
                return response.transactions
            }
            .catch { error in
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
            }
    }
}
