import UIKit

protocol MainScreenCoordinatorProtocol: AnyObject {
    func goToMedia()
}

class MainScreenCoordinator: AppCoordinatorProtocol {
    let factory: MainCoordinatorFactoryProtocol
    let storageService: StorageServiceProtocol
    let photoLibraryService: PhotoLibraryServiceProtocol
    var window: UIWindow
    var navigation: UINavigationController
    weak var goToMediaDelegate: MainScreenCoordinatorProtocol?
    
    init(window: UIWindow,
         navigation: UINavigationController,
         factory: MainCoordinatorFactoryProtocol,
         storageService: StorageServiceProtocol,
         photoLibraryService: PhotoLibraryServiceProtocol,
         goToMediaDelegate: MainScreenCoordinatorProtocol?) {
        self.window = window
        self.navigation = navigation
        self.factory = factory
        self.storageService = storageService
        self.photoLibraryService = photoLibraryService
        self.goToMediaDelegate = goToMediaDelegate
    }
    
    func start() {
        let viewController = factory.createMainScreenViewController(storageService: storageService,
                                                                    photoLibraryService: photoLibraryService,
                                                                    outputToMediaList: self)
        navigation.pushViewController(viewController, animated: true)
    }
}

extension MainScreenCoordinator: MainScreenViewControllerProtocol {
    func goToMediaList() {
        goToMediaDelegate?.goToMedia()
    }
    
    
}
