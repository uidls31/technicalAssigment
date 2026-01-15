import UIKit


class MainScreenCoordinator: AppCoordinatorProtocol {
    let factory: MainCoordinatorFactoryProtocol
    var window: UIWindow
    var navigation: UINavigationController
    
    init(window: UIWindow,
         navigation: UINavigationController,
         factory: MainCoordinatorFactoryProtocol) {
        self.window = window
        self.navigation = navigation
        self.factory = factory
    }
    
    func start() {
        let viewController = factory.createMainScreenViewController()
        navigation.setViewControllers([viewController], animated: true)
    }
}
