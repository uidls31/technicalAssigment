import UIKit

protocol MediaListViewProtocol: AnyObject {
    var navigationBarMediaList: CustomNavigationBar { get set }
    var mediaCollectionView: UICollectionView { get set }
}

class MediaListView: UIView, MediaListViewProtocol {
    
    var navigationBarMediaList: CustomNavigationBar = {
        let navBar = CustomNavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.backButton.isHidden = false
        return navBar
    }()
    
    let mediaLabel: UILabel = {
        let label = UILabel()
        let size = CGFloat.dynamicFontSize(baseFontSize: 24)
        label.text = "Media"
        label.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var mediaCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(MediaListCollectionCell.self, forCellWithReuseIdentifier: MediaListCollectionCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
        addSubview(navigationBarMediaList)
        addSubview(mediaLabel)
        addSubview(mediaCollectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            navigationBarMediaList.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            navigationBarMediaList.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            navigationBarMediaList.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            navigationBarMediaList.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.05),
            
            mediaLabel.topAnchor.constraint(equalTo: navigationBarMediaList.bottomAnchor, constant: 16),
            mediaLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            mediaCollectionView.topAnchor.constraint(equalTo: mediaLabel.bottomAnchor, constant: 24),
            mediaCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            mediaCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            mediaCollectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: UIScreen.main.isSmallScreen ? 0.7 : 0.6)
        ])
    }
}
