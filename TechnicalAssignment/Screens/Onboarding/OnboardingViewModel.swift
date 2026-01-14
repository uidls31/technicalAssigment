import UIKit

protocol OnboardingViewModelProtocol: AnyObject {
    func printSomething()
    func numberOfRowsInSection() -> Int
    func continueButtonTapped(currentIndex: Int)
    
    var onboardingArray: [OnboardingModel] { get }
    var onScrollToItem: ((Int) -> Void)? { get set }
    var onFinishOnboarding: (() -> Void)? { get set }
}

class OnboardingViewModel: OnboardingViewModelProtocol {
    
    
    var onScrollToItem: ((Int) -> Void)?
    
    var onFinishOnboarding: (() -> Void)?
    
    
    var onboardingArray: [OnboardingModel]
    
    func continueButtonTapped(currentIndex: Int) {
        let nextIndex = currentIndex + 1
        if nextIndex < onboardingArray.count {
            onScrollToItem?(nextIndex)
        } else {
            onFinishOnboarding?()
        }
    }
    
    init(onboardingArray: [OnboardingModel]) {
        self.onboardingArray = onboardingArray
    }
    
    func printSomething() {
        print("Here from viewmodel")
    }
    
    func numberOfRowsInSection() -> Int {
        onboardingArray.count
    }
    
    
}
