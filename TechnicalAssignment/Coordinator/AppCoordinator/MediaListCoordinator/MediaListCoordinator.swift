import UIKit


class MediaListCoordinator: AppCoordinatorProtocol {
    let factory: MediaListFactoryProtocol
    let mediaListService: MediaListServiceProtocol
    let photoService: PhotoLibraryServiceProtocol
    var window: UIWindow
    var navigation: UINavigationController
    
    init(window: UIWindow,
         navigation: UINavigationController,
         factory: MediaListFactoryProtocol,
         mediaListService: MediaListServiceProtocol,
         photoService: PhotoLibraryServiceProtocol) {
        self.window = window
        self.navigation = navigation
        self.factory = factory
        self.mediaListService = mediaListService
        self.photoService = photoService
    }
    
    
    func start() {
        let viewController = factory.createMediaListViewController(outputBack: self,
                                                                   mediaListService: mediaListService,
                                                                   output: self)
        navigation.pushViewController(viewController, animated: true)
    }
}

extension MediaListCoordinator: MediaListViewControllerOutputBack {
    func back() {
        navigation.popViewController(animated: true)
    }
    
    
}

extension MediaListCoordinator: MediaListViewControllerOutput {
    func goToSmartAlbum(_ type: SmartAlbumType) {
        let smartViewController = factory.createSmartAlbumViewController(outputBack: self,
                                                                         albumType: type,
                                                                         photoService: photoService)
        navigation.pushViewController(smartViewController, animated: true)
        
    }
    
    
}

extension MediaListCoordinator: SmarAlbumViewControllerProtocolOutputBack {
    func goBack() {
        navigation.popViewController(animated: true)
    }
}
