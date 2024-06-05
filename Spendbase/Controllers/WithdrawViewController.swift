import UIKit

final class WithdrawViewController: UIViewController {
    private let balance = DataService.balance
    private var sendMoneyButton: UIButton!
    private let moneyInputField = UITextField()
    private let balancelabel = UILabel()
    
    private let euroLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        validateInput()
        updateBalanceLabel()
        autoLayout()
        setupKeyboardObservers()
    }
    
    private func configureView() {
        view.backgroundColor = .mainBackground
        title = "Transfer"
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "multiply")?.withTintColor(.black, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(dismissSelf))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        sendMoneyButton = makeButton(text: "Надіслати", selector: #selector(sendHandler))
        
        [moneyInputField, sendMoneyButton, balancelabel, euroLabel].forEach { uiview in
            view.addSubview(uiview)
            uiview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        moneyInputField.placeholder = "0"
        moneyInputField.autocapitalizationType = .none
        moneyInputField.font = UIFont.boldSystemFont(ofSize: 34.0)
        moneyInputField.keyboardType = .decimalPad
        moneyInputField.textAlignment = .center
        moneyInputField.delegate = self
        
        balancelabel.font = UIFont.systemFont(ofSize: 14)
        balancelabel.numberOfLines = 2
        balancelabel.textAlignment = .center
        
        euroLabel.text = "€"
        euroLabel.font = UIFont.boldSystemFont(ofSize: 34.0)
        euroLabel.textColor = .black
    }
    
    private func updateBalanceLabel() {
        let balanceText = "€\(balance.formattedWithSeparator())"
        let fullText = "You have \(balanceText)\navailable in your balance"
        
        let attributedText = NSMutableAttributedString(string: fullText)
        let balanceRange = (fullText as NSString).range(of: balanceText)
        let fullRange = NSRange(location: 0, length: fullText.count)
        
        attributedText.addAttribute(.foregroundColor, value: UIColor.secondText, range: fullRange)
        attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: fullRange)
        

        attributedText.addAttribute(.foregroundColor, value: UIColor.black, range: balanceRange)
        attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14), range: balanceRange)
        
        balancelabel.attributedText = attributedText
    }

    
    private func autoLayout() {
        NSLayoutConstraint.activate([
            euroLabel.rightAnchor.constraint(equalTo: moneyInputField.leftAnchor, constant: -5),
            euroLabel.centerYAnchor.constraint(equalTo: moneyInputField.centerYAnchor, constant: 0),
            
            moneyInputField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            moneyInputField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            
            balancelabel.topAnchor.constraint(equalTo: moneyInputField.bottomAnchor, constant: 10),
            balancelabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            sendMoneyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            sendMoneyButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            sendMoneyButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            sendMoneyButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func validateInput() {
        guard let inputText = moneyInputField.text, let inputAmount = Double(inputText), inputAmount > 0 else {
            sendMoneyButton.alpha = 0.5
            sendMoneyButton.isEnabled = false
            return
        }
        
        if inputAmount > balance {
            sendMoneyButton.alpha = 0.5
            sendMoneyButton.isEnabled = false
            balancelabel.textColor = .red
            let balanceText = "€\(balance.formattedWithSeparator())"
            let fullText = "You only have \(balanceText)\navailable in your balance"
            
            let attributedText = NSMutableAttributedString(string: fullText)
            let balanceRange = (fullText as NSString).range(of: balanceText)
            let fullRange = NSRange(location: 0, length: fullText.count)
            
            attributedText.addAttribute(.foregroundColor, value: UIColor.red, range: fullRange)
            attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: fullRange)
            

            attributedText.addAttribute(.foregroundColor, value: UIColor.red, range: balanceRange)
            attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14), range: balanceRange)
            
            balancelabel.attributedText = attributedText
        } else {
            sendMoneyButton.alpha = 1
            sendMoneyButton.isEnabled = true
            moneyInputField.textColor = .black
            updateBalanceLabel()
        }
    }
    func generateRandomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }

    func generateRandomInt(min: Int, max: Int) -> Int {
        return Int.random(in: min...max)
    }
    
    @objc private func dismissSelf(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func sendHandler() {
        guard let inputText = moneyInputField.text, let inputAmount = Double(inputText), inputAmount > 0 else {
            sendMoneyButton.alpha = 0.5
            sendMoneyButton.isEnabled = false
            return
        }
        DataService.transactionsData.append(Transaction(
            id: generateRandomString(length: 10),
            tribeTransactionId: generateRandomString(length: 8),
            tribeCardId: generateRandomInt(min: 1000, max: 9999),
            amount: String(inputAmount),
            status: "debit",
            tribeTransactionType: "purchase",
            schemeId: generateRandomString(length: 6),
            merchantName: "Merchant" + generateRandomString(length: 5),
            pan: generateRandomString(length: 16)
        ))
        
        DataService.balance -= inputAmount
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            UIView.animate(withDuration: 0.3) {
                self.sendMoneyButton.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.sendMoneyButton.transform = .identity
        }
    }
}

extension WithdrawViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        validateInput()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "0123456789.")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        validateInput()
    }
}
