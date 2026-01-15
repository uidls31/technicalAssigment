import UIKit

protocol AppCoordinatorFactoryProtocol {
    func createOnboardingCoordinator(window: UIWindow,
                                     navigation: UINavigationController,
                                     outputApp: (any CoordinatorOutputProtocol)?) -> AppCoordinatorProtocol
    func createMainScreenCoordinator(window: UIWindow,
                                     navigation: UINavigationController) -> AppCoordinatorProtocol
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
                                     navigation: UINavigationController) -> AppCoordinatorProtocol {
        let factory = MainCoordinatorFactoryImp()
        let coordinator = MainScreenCoordinator(window: window,
                                                navigation: navigation,
                                                factory: factory)
        return coordinator
    }
}
