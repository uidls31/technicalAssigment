import UIKit

enum CoordinatorType {
    case onboarding
//    case main
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
    let factory: AppCoordinatorFactoryProtocol
    
    var window: UIWindow
    var navigation: UINavigationController
    
    private var currentCoordinator: AppCoordinatorProtocol?
    
    init(window: UIWindow,
         navigation: UINavigationController,
         factory: AppCoordinatorFactoryProtocol) {
        self.window = window
        self.navigation = navigation
        self.factory = factory
    }
    
    
    func start() {
        currentCoordinator = factory.createOnboardingCoordinator(window: window,
                                                                 navigation: navigation,
                                                                 outputApp: self)
        currentCoordinator?.start()
    }
    
    func showMainScreen() {
        currentCoordinator = factory.createMainScreenCoordinator(window: window,
                                                                 navigation: navigation)
        currentCoordinator?.start()
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
