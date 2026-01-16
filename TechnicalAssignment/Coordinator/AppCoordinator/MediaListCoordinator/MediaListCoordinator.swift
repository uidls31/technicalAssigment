import UIKit

class MediaListCoordinator: AppCoordinatorProtocol {
    let factory: MediaListFactoryProtocol
    let mediaListService: MediaListServiceProtocol
    var window: UIWindow
    var navigation: UINavigationController
    
    init(window: UIWindow,
         navigation: UINavigationController,
         factory: MediaListFactoryProtocol,
         mediaListService: MediaListServiceProtocol) {
        self.window = window
        self.navigation = navigation
        self.factory = factory
        self.mediaListService = mediaListService
    }
    
    
    func start() {
        let viewController = factory.createMediaListViewController(outputBack: self, mediaListService: mediaListService)
        navigation.pushViewController(viewController, animated: true)
    }
}

extension MediaListCoordinator: MediaListViewControllerOutputBack {
    func back() {
        navigation.popViewController(animated: true)
    }
    
    
}
