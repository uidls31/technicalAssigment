import UIKit

class SmarAlbumCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "SmarAlbumCollectionViewCell"
    
    let mainImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let selectedImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(mainImage)
        mainImage.addSubview(selectedImage)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainImage.topAnchor.constraint(equalTo: topAnchor),
            mainImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            selectedImage.trailingAnchor.constraint(equalTo: mainImage.trailingAnchor, constant: -8),
            selectedImage.bottomAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(isSelected: Bool) {
        if isSelected {
            selectedImage.image = .isSelected
        } else {
            selectedImage.image = .nonSelected
        }
    }
    
    func setImage(_ image: UIImage?) {
        mainImage.image = image
    }
    
    
}
