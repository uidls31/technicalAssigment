import UIKit

enum CoordinatorType {
    case onboarding
}

protocol AppCoordinatorProtocol {
    var window: UIWindow { get }
    var navigation: UINavigationController { get }
    func start()
}

protocol CoordinatorOutputProtocol: AnyObject {
    func finishCoordinator(_ type: CoordinatorType)
}

class AppCoordinator: AppCoordinatorProtocol {
    let mediaListService: MediaListServiceProtocol
    let factory: AppCoordinatorFactoryProtocol
    let storageService: StorageServiceProtocol
    let photoLibraryService: PhotoLibraryServiceProtocol
    
    var window: UIWindow
    var navigation: UINavigationController
    
    private var onboardingCoordinator: AppCoordinatorProtocol?
    private var mainCoordinator: AppCoordinatorProtocol?
    private var mediaListCoordinator: AppCoordinatorProtocol?
    
    init(window: UIWindow,
         navigation: UINavigationController,
         factory: AppCoordinatorFactoryProtocol,
         storageService: StorageServiceProtocol,
         photoLibraryService: PhotoLibraryServiceProtocol,
         mediaListService: MediaListServiceProtocol) {
        self.window = window
        self.navigation = navigation
        self.factory = factory
        self.storageService = storageService
        self.photoLibraryService = photoLibraryService
        self.mediaListService = mediaListService
    }
    
    func start() {
        if UserDefaults.standard.bool(forKey: "completeFirstLaunch") {
            showMainScreen()
        } else {
            showOnboarding()
        }
    }
    
    func showOnboarding() {
        let coordinator = factory.createOnboardingCoordinator(window: window,
                                                              navigation: navigation,
                                                              outputApp: self)
        onboardingCoordinator = coordinator
        coordinator.start()
    }
    
    func showMainScreen() {
        onboardingCoordinator = nil
        let coordinator = factory.createMainScreenCoordinator(window: window,
                                                              navigation: navigation,
                                                              storageService: storageService,
                                                              photoLibraryService: photoLibraryService,
                                                              goToMediaDelegate: self)
        mainCoordinator = coordinator
        coordinator.start()
    }
    
    func showMediaList() {
        let coordinator = factory.createMediaListCoordinator(window: window,
                                                             navigation: navigation,
                                                             mediaListService: mediaListService,
                                                             photoService: photoLibraryService)
        mediaListCoordinator = coordinator
        coordinator.start()
        
    }

    
}

extension AppCoordinator: CoordinatorOutputProtocol {
    func finishCoordinator(_ type: CoordinatorType) {
        switch type {
        case .onboarding:
            showMainScreen()
        }
    }
}

extension AppCoordinator: MainScreenCoordinatorProtocol {
    func goToMedia() {
        showMediaList()
    }
}
