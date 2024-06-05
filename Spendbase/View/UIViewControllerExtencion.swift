import UIKit

extension UIViewController {
    func makeButton(text: String, selector: Selector?) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        button.layer.cornerRadius = 25
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        if selector != nil {
            button.addTarget(self, action: selector!, for: .touchUpInside)
        }
        return button
    }
}
