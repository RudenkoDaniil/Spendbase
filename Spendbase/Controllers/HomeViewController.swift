import UIKit
import RxSwift

final class HomeViewController: UIViewController {
    private let accountView = AccountBalanceView()
    private let cardsPanelView = CardsPanelView()
    private let transactionsPanelView = TransactionsPanelView()
    
    private let viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        autoLayout()
        bindViewModel()
        
        viewModel.loadData()
    }
    
    private func configureView() {
        view.backgroundColor = .mainBackground
        navigationItem.title = "Money"  
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(withdrawHandler))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        [accountView, cardsPanelView, transactionsPanelView].forEach { uiview in
            view.addSubview(uiview)
            uiview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        transactionsPanelView.seeAllButtonAction = {
            let overviewViewController = TransactionsViewController()
            let navigationController = UINavigationController(rootViewController: overviewViewController)
            navigationController.modalPresentationStyle = .formSheet
            self.present(navigationController, animated: true, completion: nil)
        }
        cardsPanelView.seeAllButtonAction = {
            let overviewViewController = ComingSoonViewController(title: "")
            let navigationController = UINavigationController(rootViewController: overviewViewController)
            navigationController.modalPresentationStyle = .formSheet
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    private func autoLayout() {
        NSLayoutConstraint.activate([
            accountView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            accountView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            accountView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            accountView.heightAnchor.constraint(equalToConstant: 74),
            
            cardsPanelView.topAnchor.constraint(equalTo: accountView.bottomAnchor, constant: 15),
            cardsPanelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardsPanelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cardsPanelView.heightAnchor.constraint(equalToConstant: 216),
            
            transactionsPanelView.topAnchor.constraint(equalTo: cardsPanelView.bottomAnchor, constant: 15),
            transactionsPanelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            transactionsPanelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            transactionsPanelView.heightAnchor.constraint(equalToConstant: 216)
        ])
    }
    
    private func bindViewModel() {
        viewModel.balance
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] balance in
                let image = UIImage(named: "EUFlag")
                self?.accountView.configure(image: image, name: "EUR account", balance: balance)
            })
            .disposed(by: disposeBag)
        
        viewModel.cards
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] cards in
                let cardTitles = cards.suffix(3).map { $0.cardName } 
                self?.cardsPanelView.setCards(cardTitles)
            })
            .disposed(by: disposeBag)
        
        viewModel.transactions
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] transactions in
                let transactionData = transactions.suffix(3).compactMap { transaction -> (title: String, subtitle: String, amount: Double, status: TransactionStatus)? in
                    guard let status = TransactionStatus(from: transaction.status) else { 
                        return nil
                    }
                    return (title: transaction.merchantName, subtitle: "\(transaction.tribeCardId)", amount: Double(transaction.amount) ?? 0.0, status: status)
                }
                self?.transactionsPanelView.setTransactions(transactionData.reversed())
            })
            .disposed(by: disposeBag)
    }
    
    @objc func withdrawHandler() {
        let withdrawViewController = WithdrawViewController()
        let navigationController = UINavigationController(rootViewController: withdrawViewController)
        navigationController.modalPresentationStyle = .formSheet
        present(navigationController, animated: true, completion: nil)
    }
}
