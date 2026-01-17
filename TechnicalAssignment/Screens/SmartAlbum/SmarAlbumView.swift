import UIKit

protocol SmarAlbumViewProtocol: AnyObject {
    var navigationBarSmartView: CustomNavigationBar { get set }
    var headerLabel: UILabel { get set }
    var smartAlbumCollectionView: UICollectionView { get set }
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
        label.text = "56.5 GB"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cameraCountingLabel: UILabel = {
        let label = UILabel()
        let size = CGFloat.dynamicFontSize(baseFontSize: 14)
        label.font = UIFont.systemFont(ofSize: size, weight: .regular)
        label.textColor = .graySmarAlbum
        label.text = "TEST"
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
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .white
        setupViews()
        setupConstraints()
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
            firstContainer.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
            
            secondContainer.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8),
            secondContainer.leadingAnchor.constraint(equalTo: firstContainer.trailingAnchor, constant: 8),
            secondContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.04),
            secondContainer.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25),
            
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
            smartAlbumCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
