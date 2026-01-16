import UIKit

class MediaListCoordinator: AppCoordinatorProtocol {
    let factory: MediaListFactoryProtocol
    var window: UIWindow
    var navigation: UINavigationController
    
    init(window: UIWindow,
         navigation: UINavigationController,
         factory: MediaListFactoryProtocol) {
        self.window = window
        self.navigation = navigation
        self.factory = factory
    }
    
    
    func start() {
        let viewController = factory.createMediaListViewController(outputBack: self)
        navigation.pushViewController(viewController, animated: true)
    }
}

extension MediaListCoordinator: MediaListViewControllerOutputBack {
    func back() {
        navigation.popViewController(animated: true)
    }
    
    
}
