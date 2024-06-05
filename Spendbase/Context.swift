import UIKit

class AppContext {
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    public func start() {
        let vc = LoadViewController()
        
        self.loadDataThenStartApp()
        
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
    
    private func loadDataThenStartApp() {
        // To load from api
        /*
        DataService.loadCardsData(completion: { result in
            if result {
                self.startTheApp()
            }
        })
         */
        // Random Data
        DataService.loadRandomData { result in
            if result {
                self.startTheApp()
            }
        }
    }
    
    private func startTheApp() {
        let vc = TabBarController()
        window.rootViewController = vc
    }
    
}
