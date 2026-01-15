import UIKit

protocol OnboardingCoordinatorFactoryProtocol {
    func createOnboardingViewController(output: (any OnboardingViewControllerOutput)?) -> UIViewController
}

struct OnboardingCoordinatorFactoryImp: OnboardingCoordinatorFactoryProtocol {
    
    func createOnboardingViewController(output: (any OnboardingViewControllerOutput)?) -> UIViewController {
        let onboardingArray: [OnboardingModel] = OnboardingModel.setupModels()
        let customOnboardingView: OnboardingViewProtocol = OnboardingView()
        let viewModelOnboarding: OnboardingViewModelProtocol = OnboardingViewModel(onboardingArray: onboardingArray)
        let viewController = OnboardingViewController(
            customOnboardingView: customOnboardingView,
            viewModelOnboarding: viewModelOnboarding,
            output: output)
        return viewController
    }
}
