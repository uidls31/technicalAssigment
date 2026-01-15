import UIKit

protocol OnboardingViewProtocol {
    var onTapContinue: (() -> Void)? { get set }
    var onboardingCollectionView: UICollectionView { get set }
    func scroll(to index: Int)
}

class OnboardingView: UIView, OnboardingViewProtocol {
    
    var onTapContinue: (() -> Void)?
    
    var onboardingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let onboardingPageControll: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 3
        pageControl.pageIndicatorTintColor = .pageColorOnb
        pageControl.currentPageIndicatorTintColor = .onboardingButton
        return pageControl
        
    }()
    
    
    lazy var continueButton: UIButton = {
        let button = UIButton()
        let size = CGFloat.dynamicFontSize(baseFontSize: 16)
        button.titleLabel?.font = UIFont.systemFont(ofSize: size, weight: .medium)
        button.setTitle("Continue", for: .normal)
        button.backgroundColor = .onboardingButton
        button.layer.cornerRadius = 10
        button.applyPressAnimation()
        button.addTarget(self, action: #selector(tapContinue), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scroll(to index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        onboardingCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        onboardingPageControll.currentPage = index
    }
    
    private func setupViews() {
        addSubview(onboardingCollectionView)
        addSubview(onboardingPageControll)
        addSubview(continueButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            continueButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.08),
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: UIScreen.main.isSmallScreen ? -15 : -30),
            
            onboardingPageControll.centerXAnchor.constraint(equalTo: continueButton.centerXAnchor),
            onboardingPageControll.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: UIScreen.main.isSmallScreen ? -7 : -14),
            
            onboardingCollectionView.topAnchor.constraint(equalTo: topAnchor),
            onboardingCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            onboardingCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            onboardingCollectionView.bottomAnchor.constraint(equalTo: onboardingPageControll.topAnchor)
        ])
    }
    
    @objc private func tapContinue() {
        onTapContinue?()
    }
}

