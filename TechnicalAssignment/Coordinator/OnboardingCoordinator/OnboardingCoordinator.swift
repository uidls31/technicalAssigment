import UIKit

final class OnboardingCoordinator: AppCoordinatorProtocol {
    
    let factory: OnboardingCoordinatorFactoryProtocol
    var window: UIWindow
    var navigation: UINavigationController
    weak var outputApp: CoordinatorOutputProtocol?
    
    init(window: UIWindow,
         navigation: UINavigationController,
         factory: OnboardingCoordinatorFactoryProtocol,
         outputApp: CoordinatorOutputProtocol?) {
        self.window = window
        self.navigation = navigation
        self.factory = factory
        self.outputApp = outputApp
    }
    
    func start() {
        let viewControlerr = factory.createOnboardingViewController(output: self)
        navigation.pushViewController(viewControlerr, animated: true)
    }
    
    
}

extension OnboardingCoordinator: OnboardingViewControllerOutput {
    func goToMainScreen() {
        outputApp?.finishCoordinator(.onboarding)
    }
}
