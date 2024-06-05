import UIKit

final class TransactionsPanelView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent transactions"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See All", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(seeAllButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var seeAllButtonAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 15
        
        addSubview(titleLabel)
        addSubview(seeAllButton)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            
            seeAllButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            seeAllButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
    
    @objc private func seeAllButtonTapped() {
        seeAllButtonAction?()
    }
    
    public func setTransactions(_ transactions: [(title: String, subtitle: String, amount: Double, status: TransactionStatus)]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let maxTransactionsToShow = min(transactions.count, 3)
        for i in 0..<maxTransactionsToShow {
            let transactionView = TransactionView()
            transactionView.heightAnchor.constraint(equalToConstant: 56).isActive = true
            transactionView.configure(with: transactions[i])
            stackView.addArrangedSubview(transactionView)
        }
    }
}
