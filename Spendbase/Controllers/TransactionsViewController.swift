import UIKit
import RxSwift
import RxCocoa

final class TransactionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    private let viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    private var transactions: [(title: String, subtitle: String, amount: Double, status: TransactionStatus)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupTableView()
        bindViewModel()
        
        viewModel.loadData()
    }
    
    private func configureView() {
        view.backgroundColor = .mainBackground
        title = "Transactions"
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "multiply")?.withTintColor(.black, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(dismissSelf))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc private func dismissSelf(){
        dismiss(animated: true, completion: nil)
    }
    
    private func bindViewModel() {
        viewModel.transactions
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] transactions in
                self?.transactions = transactions.reversed().compactMap { transaction -> (title: String, subtitle: String, amount: Double, status: TransactionStatus)? in
                    guard let status = TransactionStatus(from: transaction.status) else {
                        return nil
                    }
                    return (title: transaction.merchantName, subtitle: "\(transaction.tribeCardId)", amount: Double(transaction.amount) ?? 0.0, status: status)
                }
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.reuseIdentifier, for: indexPath) as? TransactionTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: transactions[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}
