import UIKit

final class CardsPanelView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "My cards"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See All", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(seeAllButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
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
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    @objc private func seeAllButtonTapped() {
        seeAllButtonAction?()
    }
    
    public func setCards(_ cards: [String]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let maxCardsToShow = min(cards.count, 3)
        for i in 0..<maxCardsToShow {
            let cardView = createCardView(cardText: cards[i])
            stackView.addArrangedSubview(cardView)
        }
    }
    
    private func createCardView(cardText: String) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let cardView = CardView(number: "4141", backgroundColor: UIColor(red: 43/255, green: 44/255, blue: 57/255, alpha: 1.0), borderColor: UIColor(white: 1.0, alpha: 0.2))
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        cardView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        let label = UILabel()
        label.text = cardText
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(cardView)
        containerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            cardView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            label.leadingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return containerView
    }
}
