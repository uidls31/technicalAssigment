import UIKit

protocol AppCoordinatorFactoryProtocol {
    func createOnboardingCoordinator(window: UIWindow,
                                     navigation: UINavigationController,
                                     outputApp: (any CoordinatorOutputProtocol)?) -> AppCoordinatorProtocol
    func createMainScreenCoordinator(window: UIWindow,
                                     navigation: UINavigationController,
                                     storageService: any StorageServiceProtocol,
                                     photoLibraryService: any PhotoLibraryServiceProtocol,
                                     goToMediaDelegate: (any MainScreenCoordinatorProtocol)?) -> AppCoordinatorProtocol
    func createMediaListCoordinator(window: UIWindow,
                                    navigation: UINavigationController,
                                    mediaListService: any MediaListServiceProtocol) -> AppCoordinatorProtocol
}

struct AppCoordinatorFactoryImp: AppCoordinatorFactoryProtocol {
    func createOnboardingCoordinator(window: UIWindow,
                                     navigation: UINavigationController,
                                     outputApp: (any CoordinatorOutputProtocol)?) -> AppCoordinatorProtocol {
        let factory = OnboardingCoordinatorFactoryImp()
        let coordinator = OnboardingCoordinator(window: window,
                                                navigation: navigation,
                                                factory: factory,
                                                outputApp: outputApp)
        return coordinator
    }
    
    func createMainScreenCoordinator(window: UIWindow,
                                     navigation: UINavigationController,
                                     storageService: any StorageServiceProtocol,
                                     photoLibraryService: any PhotoLibraryServiceProtocol,
                                     goToMediaDelegate: (any MainScreenCoordinatorProtocol)?) -> AppCoordinatorProtocol {
        let factory = MainCoordinatorFactoryImp()
        let coordinator = MainScreenCoordinator(window: window,
                                                navigation: navigation,
                                                factory: factory,
                                                storageService: storageService,
                                                photoLibraryService: photoLibraryService,
                                                goToMediaDelegate: goToMediaDelegate)
        return coordinator
    }
    
    func createMediaListCoordinator(window: UIWindow,
                                    navigation: UINavigationController,
                                    mediaListService: any MediaListServiceProtocol) -> AppCoordinatorProtocol {
        let factory = MediaListFactoryImp()
        let coordinator = MediaListCoordinator(window: window,
                                               navigation: navigation,
                                               factory: factory,
                                               mediaListService: mediaListService)
        return coordinator
    }
}
