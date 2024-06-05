import UIKit

final class TransactionView: UIView {
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    private let statusIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let redDotView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.layer.cornerRadius = 5
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(amountLabel)
        addSubview(statusIconImageView)
        addSubview(redDotView)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            redDotView.rightAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: -5),
            redDotView.bottomAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: -5),
            redDotView.widthAnchor.constraint(equalToConstant: 10),
            redDotView.heightAnchor.constraint(equalToConstant: 10),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: amountLabel.leadingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: amountLabel.leadingAnchor, constant: -10),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
            
            amountLabel.rightAnchor.constraint(equalTo: statusIconImageView.leftAnchor, constant: -10),
            amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            statusIconImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            statusIconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            statusIconImageView.widthAnchor.constraint(equalToConstant: 20),
            statusIconImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    public func configure(with transaction: (title: String, subtitle: String, amount: Double, status: TransactionStatus)) {
        titleLabel.text = transaction.title
        subtitleLabel.text = transaction.subtitle
        amountLabel.text = "€\(transaction.amount.formattedWithSeparator())"
        
        switch transaction.status {
        case .load:
            amountLabel.textColor = .systemGreen
            statusIconImageView.isHidden = true
            redDotView.isHidden = true
            iconImageView.image = UIImage(named: "creditcard")
        case .debit:
            amountLabel.textColor = .black
            statusIconImageView.isHidden = false
            statusIconImageView.image = UIImage(named: "shape")
            redDotView.isHidden = true
            iconImageView.image = UIImage(named: "creditcard")
        case .credit:
            amountLabel.textColor = .gray
            statusIconImageView.isHidden = true
            redDotView.isHidden = true
            iconImageView.image = UIImage(named: "arrow.down")
        case .cancelled:
            amountLabel.textColor = .gray
            statusIconImageView.isHidden = true
            redDotView.isHidden = false
            iconImageView.image = UIImage(named: "creditcard")
        }
    }
}
