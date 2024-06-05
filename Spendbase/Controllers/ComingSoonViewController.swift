import UIKit

final class ComingSoonViewController: UIViewController {
    
    private let comingSoonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        return imageView
    }()
    
    private let comingSoonLabel: UILabel = {
        let label = UILabel()
        label.text = "Coming soon"
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var pageTitle: String

    init(title: String) {
        self.pageTitle = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        autoLayout()
    }
    
    private func configureView() {
        view.backgroundColor = .mainBackground
        navigationItem.title = pageTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        stackView.addArrangedSubview(comingSoonImageView)
        stackView.addArrangedSubview(comingSoonLabel)
        view.addSubview(stackView)
    }
    
    private func autoLayout() {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            comingSoonImageView.widthAnchor.constraint(equalToConstant: 80),
            comingSoonImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
}
