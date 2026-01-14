import UIKit

class OnboardingViewController: UIViewController {
    
    var customOnboardingView: OnboardingViewProtocol
    let viewModelOnboarding: OnboardingViewModelProtocol
    
    init(customOnboardingView: OnboardingViewProtocol,
         viewModelOnboarding: OnboardingViewModelProtocol) {
        self.customOnboardingView = customOnboardingView
        self.viewModelOnboarding = viewModelOnboarding
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        view = customOnboardingView as? UIView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupActions()
        setupBinding()
    }
    
    private func setupActions() {
        setupContinue()
    }
    
    private func setupBinding() {
        viewModelOnboarding.onScrollToItem = { [weak self] index in
            self?.customOnboardingView.scroll(to: index)
        }
        
        viewModelOnboarding.onFinishOnboarding = { [weak self] in
            self?.navigationController?.pushViewController(MainScreenViewController(), animated: true)
        }
    }
    
    private func setupContinue() {
        customOnboardingView.onTapContinue = { [weak self] in
            guard let self else { return }
            let currentIndex = Int(customOnboardingView.onboardingCollectionView.contentOffset.x / customOnboardingView.onboardingCollectionView.frame.width)
            viewModelOnboarding.continueButtonTapped(currentIndex: currentIndex)
        }
    }
    
    private func setupCollectionView() {
        customOnboardingView.onboardingCollectionView.delegate = self
        customOnboardingView.onboardingCollectionView.dataSource = self
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModelOnboarding.numberOfRowsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        cell.configure(with: viewModelOnboarding.onboardingArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
}
