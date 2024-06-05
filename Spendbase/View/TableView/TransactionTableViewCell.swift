import UIKit

final class TransactionTableViewCell: UITableViewCell {
    static let reuseIdentifier = "TransactionTableViewCell"
    
    private let transactionView = TransactionView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        contentView.addSubview(transactionView)
        transactionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            transactionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            transactionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            transactionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            transactionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with transaction: (title: String, subtitle: String, amount: Double, status: TransactionStatus)) {
        transactionView.configure(with: transaction)
    }
}
