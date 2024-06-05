import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    private func configureView() {
        self.tabBar.backgroundColor = .white
        self.tabBar.tintColor = .systemBlue

        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: ComingSoonViewController(title: "Transactions"))
        let vc3 = UINavigationController(rootViewController: ComingSoonViewController(title: "My Cards"))
        let vc4 = UINavigationController(rootViewController: ComingSoonViewController(title: "Account"))

        vc1.title = "Money"
        vc2.title = "Transactions"
        vc3.title = "My Cards"
        vc4.title = "Account"

        self.setViewControllers([vc1, vc2, vc3, vc4], animated: false)

        let images = ["Home", "Transactions", "Card", "Account"]

        guard let items = self.tabBar.items else {
            return
        }

        for x in 0..<items.count {
            items[x].image = UIImage(named: images[x])
            items[x].title = images[x]
        }
    }
}
