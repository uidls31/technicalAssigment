import UIKit

protocol SmarAlbumViewProtocol: AnyObject {
    func setupForCameraCountingLabel(_ text: String, type: SmartAlbumType)
    func setupForMaterialLabel(_ text: String)
    func updateDeleteTitle(_ text: String, isEnabled: Bool)
    func updateSelectedTitle(isSelected: Bool)
    var navigationBarSmartView: CustomNavigationBar { get set }
    var headerLabel: UILabel { get set }
    var smartAlbumCollectionView: UICollectionView { get set }
    var onTapDeleteBUtton: (() -> Void)? { get set }
    var onTapDeselectAllButton: (() -> Void)? { get set }
}

class SmarAlbumView: UIView, SmarAlbumViewProtocol {
    
    var navigationBarSmartView: CustomNavigationBar = {
        let navBar = CustomNavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.backButton.isHidden = false
        return navBar
    }()
    
    var headerLabel: UILabel = {
        let label = UILabel()
        let size = CGFloat.dynamicFontSize(baseFontSize: 24)
        label.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let firstContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.masksToBounds = false
        return view
    }()
    
    let cameraSmartAlbum: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = .cameraSmartAlbum
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let materialSmartAlbum: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = .materialSmartAlbum
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let countingMaterialLabel: UILabel = {
        let label = UILabel()
        let size = CGFloat.dynamicFontSize(baseFontSize: 14)
        label.font = UIFont.systemFont(ofSize: size, weight: .regular)
        label.textColor = .graySmarAlbum
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cameraCountingLabel: UILabel = {
        let label = UILabel()
        let size = CGFloat.dynamicFontSize(baseFontSize: 14)
        label.font = UIFont.systemFont(ofSize: size, weight: .regular)
        label.textColor = .graySmarAlbum
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let secondContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.masksToBounds = false
        return view
    }()
    
    var smartAlbumCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SmarAlbumCollectionViewCell.self, forCellWithReuseIdentifier: SmarAlbumCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        let size = CGFloat.dynamicFontSize(baseFontSize: 16)
        button.titleLabel?.font = UIFont.systemFont(ofSize: size, weight: .medium)
        button.backgroundColor = .onboardingButton
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(tapDeleteBUtton), for: .touchUpInside)
        button.applyPressAnimation()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var gradientView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    let containerForButton: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4
        view.clipsToBounds = false
        return view
    }()
    
    let completedImage: UIImageView = {
        let image = UIImageView()
        image.image = .completed
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var selectedTitle: UILabel = {
        let title = UILabel()
        let size = CGFloat.dynamicFontSize(baseFontSize: 14)
        title.font = UIFont.systemFont(ofSize: size, weight: .medium)
        title.text = "Selected All"
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .center
        return title
    }()
    
    var onTapDeleteBUtton: (() -> Void)?
    var onTapDeselectAllButton: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .white
        setupGestureForAll()
        setupGradient()
        setupViews()
        setupConstraints()
    }
    
    private func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.white.withAlphaComponent(0.0).cgColor,
            UIColor.white.withAlphaComponent(1.0).cgColor,
            UIColor.white.withAlphaComponent(1.0).cgColor
        ]
        gradientLayer.locations = [0.0, 0.8, 1.0]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 120)
        
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        gradientView.image = image
    }
    
    private func setupGestureForAll() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapDeselectAllButton))
        containerForButton.addGestureRecognizer(gesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(navigationBarSmartView)
        addSubview(headerLabel)
        addSubview(firstContainer)
        addSubview(secondContainer)
        firstContainer.addSubview(cameraSmartAlbum)
        firstContainer.addSubview(cameraCountingLabel)
        secondContainer.addSubview(materialSmartAlbum)
        secondContainer.addSubview(countingMaterialLabel)
        addSubview(smartAlbumCollectionView)
        addSubview(deleteButton)
        addSubview(gradientView)
        addSubview(containerForButton)
        containerForButton.addSubview(completedImage)
        containerForButton.addSubview(selectedTitle)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            navigationBarSmartView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            navigationBarSmartView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            navigationBarSmartView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            navigationBarSmartView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.05),
            
            headerLabel.topAnchor.constraint(equalTo: navigationBarSmartView.bottomAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            firstContainer.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8),
            firstContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            firstContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.04),
            firstContainer.trailingAnchor.constraint(equalTo: cameraCountingLabel.trailingAnchor, constant: 8),
            
            secondContainer.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8),
            secondContainer.leadingAnchor.constraint(equalTo: firstContainer.trailingAnchor, constant: 8),
            secondContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.04),
            secondContainer.trailingAnchor.constraint(equalTo: countingMaterialLabel.trailingAnchor, constant: 8),
            
            cameraSmartAlbum.centerYAnchor.constraint(equalTo: firstContainer.centerYAnchor),
            cameraSmartAlbum.leadingAnchor.constraint(equalTo: firstContainer.leadingAnchor, constant: 8),
            
            cameraCountingLabel.centerYAnchor.constraint(equalTo: firstContainer.centerYAnchor),
            cameraCountingLabel.leadingAnchor.constraint(equalTo: cameraSmartAlbum.trailingAnchor, constant: 8),
            
            materialSmartAlbum.centerYAnchor.constraint(equalTo: secondContainer.centerYAnchor),
            materialSmartAlbum.leadingAnchor.constraint(equalTo: secondContainer.leadingAnchor, constant: 8),
            
            countingMaterialLabel.centerYAnchor.constraint(equalTo: secondContainer.centerYAnchor),
            countingMaterialLabel.leadingAnchor.constraint(equalTo: materialSmartAlbum.trailingAnchor, constant: 8),
            
            smartAlbumCollectionView.topAnchor.constraint(equalTo: countingMaterialLabel.bottomAnchor, constant: 24),
            smartAlbumCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            smartAlbumCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            smartAlbumCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            deleteButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.08),
            deleteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            deleteButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: UIScreen.main.isSmallScreen ? -15 : -30),
            
            gradientView.topAnchor.constraint(equalTo: deleteButton.bottomAnchor),
            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 100),
            
            containerForButton.centerYAnchor.constraint(equalTo: navigationBarSmartView.centerYAnchor),
            containerForButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerForButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.03),
            containerForButton.leadingAnchor.constraint(equalTo: selectedTitle.leadingAnchor, constant: -36),
            
            completedImage.centerYAnchor.constraint(equalTo: containerForButton.centerYAnchor),
            completedImage.leadingAnchor.constraint(equalTo: containerForButton.leadingAnchor, constant: 8),
            
            selectedTitle.centerYAnchor.constraint(equalTo: containerForButton.centerYAnchor),
            selectedTitle.trailingAnchor.constraint(equalTo: containerForButton.trailingAnchor, constant: -8)
        ])
    }
    
    func setupForCameraCountingLabel(_ text: String, type: SmartAlbumType) {
        cameraCountingLabel.text = text
        switch type {
        case .screenshots:
            cameraCountingLabel.text = "Photos \(text)"
        case .livePhotos:
            cameraCountingLabel.text = "Photos \(text)"
        case .screenRecordings:
            cameraCountingLabel.text = "Videos \(text)"
        }
    }
    
    func setupForMaterialLabel(_ text: String) {
        countingMaterialLabel.text = text
    }
    
    @objc private func tapDeleteBUtton() {
        onTapDeleteBUtton?()
    }
    
    @objc private func tapDeselectAllButton() {
        onTapDeselectAllButton?()
    }
    
    func updateDeleteTitle(_ text: String, isEnabled: Bool) {
        deleteButton.setTitle(text, for: .normal)
        deleteButton.isEnabled = isEnabled
    }
    
    func updateSelectedTitle(isSelected: Bool) {
        if isSelected {
            selectedTitle.text = "Deselected All"
        } else {
            selectedTitle.text = "Selected All"
        }
    }
}
