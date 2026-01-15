import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
//    let onboardingModels: [OnboardingModel] = OnboardingModel.setupModels()
//    let onboardingView: OnboardingViewProtocol = OnboardingView()
//    lazy var viewModelOnboarding: OnboardingViewModelProtocol = OnboardingViewModel(onboardingArray: onboardingModels)

    var window: UIWindow?
    var appCoordinator: AppCoordinatorProtocol?
    let navigation = UINavigationController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.overrideUserInterfaceStyle = .light
//        let navigation = UINavigationController(rootViewController:OnboardingViewController(customOnboardingView: onboardingView, viewModelOnboarding: viewModelOnboarding) )
//        window?.rootViewController = navigation
//        window?.makeKeyAndVisible()
        startAppCoordinator()
        return true
    }
    
    private func startAppCoordinator() {
        let factory = AppCoordinatorFactoryImp()
        appCoordinator = AppCoordinator(window: window ?? UIWindow(),
                                        navigation: navigation,
                                        factory: factory)
        appCoordinator?.start()
        navigation.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
}

