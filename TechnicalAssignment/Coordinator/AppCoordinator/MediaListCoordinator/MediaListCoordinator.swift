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
                                                                   output: self,
                                                                   outputToGroupAlbum: self)
        navigation.pushViewController(viewController, animated: true)
    }
    
    func goBackCoord() {
        navigation.popViewController(animated: true)
    }
}

extension MediaListCoordinator: MediaListViewControllerOutputBack {
    func back() {
        goBackCoord()
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
        goBackCoord()
    }
}

extension MediaListCoordinator: MediaListViewControllerOutputToGroupAlbum {
    func goToGroupAlbum(_ type: GroupAlbum) {
        let groupAlbumViewController = factory.createGroupAlbumViewController(outputBackGroup: self,
                                                                              groupAlbumType: type,
                                                                              photoService: photoService)
        navigation.pushViewController(groupAlbumViewController, animated: true)
    }

    
}

extension MediaListCoordinator: GroupAlbumViewControllerOutputBack {
    func goGroupBack() {
        goBackCoord()
    }

}
