import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let onboardingModels: [OnboardingModel] = OnboardingModel.setupModels()
    let onboardingView: OnboardingViewProtocol = OnboardingView()
    lazy var viewModelOnboarding: OnboardingViewModelProtocol = OnboardingViewModel(onboardingArray: onboardingModels)

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigation = UINavigationController(rootViewController:OnboardingViewController(customOnboardingView: onboardingView, viewModelOnboarding: viewModelOnboarding) )
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        return true
    }
}

