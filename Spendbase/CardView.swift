import UIKit

class CardView: UIView {
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(number: String, backgroundColor: UIColor, borderColor: UIColor) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = borderColor.cgColor
        
        addSubview(numberLabel)
        numberLabel.text = number
        
        NSLayoutConstraint.activate([
            numberLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -4),
            numberLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateAppearance(backgroundColor: UIColor, borderColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.layer.borderColor = borderColor.cgColor
    }
}
