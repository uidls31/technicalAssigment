import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "OnboardingCollectionViewCell"
    
    
    private let screenImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let storageImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let shadowImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = .shadowElipse
        return image
    }()
    
    
    private let stackViewForOnboarding: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        let size = CGFloat.dynamicFontSize(baseFontSize: 24)
        label.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private let subMainLabel: UILabel = {
        let label = UILabel()
        let size = CGFloat.dynamicFontSize(baseFontSize: 14)
        label.font = UIFont.systemFont(ofSize: size, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .subTextOnb
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(screenImage)
        contentView.addSubview(shadowImage)
        contentView.addSubview(stackViewForOnboarding)
        contentView.addSubview(storageImage)
        stackViewForOnboarding.addArrangedSubview(mainLabel)
        stackViewForOnboarding.addArrangedSubview(subMainLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            screenImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: UIScreen.main.isSmallScreen ? -70 : -60),
            screenImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            screenImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
            screenImage.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            
            shadowImage.topAnchor.constraint(equalTo: screenImage.bottomAnchor, constant: 30),
            shadowImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            stackViewForOnboarding.topAnchor.constraint(equalTo: shadowImage.bottomAnchor, constant: 22),
            stackViewForOnboarding.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            storageImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.12),
            storageImage.bottomAnchor.constraint(equalTo: shadowImage.topAnchor, constant: -5),
            storageImage.centerXAnchor.constraint(equalTo: shadowImage.centerXAnchor)
        ])
    }
    
    
    
    func configure(with model: OnboardingModel) {
        screenImage.image = model.mainImage
        mainLabel.text = model.mainTitle
        subMainLabel.text = model.subTitle
        storageImage.image = model.storageImage
    }
}
