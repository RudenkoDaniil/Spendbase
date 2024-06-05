import RxSwift
import RxCocoa

final class HomeViewModel {
    let balance: Observable<Double>
    let cards: Observable<[Card]>
    let transactions: Observable<[Transaction]>
    
    init(dataService: DataService = .shared) {
        balance = DataService.getBalance()
        cards = DataService.getCardsData()
        transactions = DataService.getTransactionsData()
    }
    
    func loadData() {
        DataService.loadCardsData { success in
            if !success {
                // Handle error
            }
        }
    }
}
