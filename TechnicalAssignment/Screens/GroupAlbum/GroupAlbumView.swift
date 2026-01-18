import UIKit

protocol GroupAlbumViewProtocol: AnyObject {
    var navigationBarGroupAlbum: CustomNavigationBar { get set }
    var onDidTapDeleteButton: (() -> Void)? { get set }
    var headerGroupLabel: UILabel { get set }
    var groupAlbumCollectionView: UICollectionView { get set }
}

class GroupAlbumView: UIView, GroupAlbumViewProtocol {
    var onDidTapDeleteButton: (() -> Void)?
    
    var navigationBarGroupAlbum: CustomNavigationBar = {
        let navBar = CustomNavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.backButton.isHidden = false
        return navBar
    }()
    
    var headerGroupLabel: UILabel = {
        let label = UILabel()
        let size = CGFloat.dynamicFontSize(baseFontSize: 24)
        label.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    let cameraGroupAlbum: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = .cameraSmartAlbum
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let cameraCountingLabel: UILabel = {
        let label = UILabel()
        let size = CGFloat.dynamicFontSize(baseFontSize: 14)
        label.font = UIFont.systemFont(ofSize: size, weight: .regular)
        label.textColor = .graySmarAlbum
        label.text = "dsadsadasdas"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    let materialGroupAlbum: UIImageView = {
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
        label.text = "dasdasdasdasdsa"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        let size = CGFloat.dynamicFontSize(baseFontSize: 16)
        button.titleLabel?.font = UIFont.systemFont(ofSize: size, weight: .medium)
        button.backgroundColor = .onboardingButton
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        button.applyPressAnimation()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var gradientView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    var groupAlbumCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
//        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GroupAlbumCollectionViewCell.self, forCellWithReuseIdentifier: GroupAlbumCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
//        collectionView.backgroundColor = .red
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupGradient()
        setupViews()
        setupConstraints()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(groupAlbumCollectionView)
        addSubview(navigationBarGroupAlbum)
        addSubview(headerGroupLabel)
        addSubview(containerForButton)
        containerForButton.addSubview(completedImage)
        containerForButton.addSubview(selectedTitle)
        addSubview(firstContainer)
        firstContainer.addSubview(cameraGroupAlbum)
        firstContainer.addSubview(cameraCountingLabel)
        addSubview(secondContainer)
        secondContainer.addSubview(materialGroupAlbum)
        secondContainer.addSubview(countingMaterialLabel)
        addSubview(deleteButton)
        addSubview(gradientView)
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
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            navigationBarGroupAlbum.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            navigationBarGroupAlbum.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            navigationBarGroupAlbum.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            navigationBarGroupAlbum.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.05),
            
            headerGroupLabel.topAnchor.constraint(equalTo: navigationBarGroupAlbum.bottomAnchor, constant: 16),
            headerGroupLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            containerForButton.centerYAnchor.constraint(equalTo: navigationBarGroupAlbum.centerYAnchor),
            containerForButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerForButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.03),
            containerForButton.leadingAnchor.constraint(equalTo: selectedTitle.leadingAnchor, constant: -36),
            
            completedImage.centerYAnchor.constraint(equalTo: containerForButton.centerYAnchor),
            completedImage.leadingAnchor.constraint(equalTo: containerForButton.leadingAnchor, constant: 8),
            
            selectedTitle.centerYAnchor.constraint(equalTo: containerForButton.centerYAnchor),
            selectedTitle.trailingAnchor.constraint(equalTo: containerForButton.trailingAnchor, constant: -8),
            
            firstContainer.topAnchor.constraint(equalTo: headerGroupLabel.bottomAnchor, constant: 8),
            firstContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            firstContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.04),
            firstContainer.trailingAnchor.constraint(equalTo: cameraCountingLabel.trailingAnchor, constant: 8),
            
            cameraGroupAlbum.centerYAnchor.constraint(equalTo: firstContainer.centerYAnchor),
            cameraGroupAlbum.leadingAnchor.constraint(equalTo: firstContainer.leadingAnchor, constant: 8),
            
            cameraCountingLabel.centerYAnchor.constraint(equalTo: firstContainer.centerYAnchor),
            cameraCountingLabel.leadingAnchor.constraint(equalTo: cameraGroupAlbum.trailingAnchor, constant: 8),
            
            secondContainer.topAnchor.constraint(equalTo: headerGroupLabel.bottomAnchor, constant: 8),
            secondContainer.leadingAnchor.constraint(equalTo: firstContainer.trailingAnchor, constant: 8),
            secondContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.04),
            secondContainer.trailingAnchor.constraint(equalTo: countingMaterialLabel.trailingAnchor, constant: 8),
            
            materialGroupAlbum.centerYAnchor.constraint(equalTo: secondContainer.centerYAnchor),
            materialGroupAlbum.leadingAnchor.constraint(equalTo: secondContainer.leadingAnchor, constant: 8),
            
            countingMaterialLabel.centerYAnchor.constraint(equalTo: secondContainer.centerYAnchor),
            countingMaterialLabel.leadingAnchor.constraint(equalTo: materialGroupAlbum.trailingAnchor, constant: 8),
            
            groupAlbumCollectionView.topAnchor.constraint(equalTo: countingMaterialLabel.bottomAnchor, constant: 24),
            groupAlbumCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            groupAlbumCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            groupAlbumCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            deleteButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.08),
            deleteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            deleteButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: UIScreen.main.isSmallScreen ? -15 : -30),
            
            gradientView.topAnchor.constraint(equalTo: deleteButton.bottomAnchor),
            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 100),
            
        ])
    }
    
    @objc private func didTapDeleteButton() {
        onDidTapDeleteButton?()
    }
}
