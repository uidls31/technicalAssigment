import UIKit

class CustomGroupSelectablePhotoView: UIView {
    
    let mainImageView: UIImageView = {
        let image = UIImageView()
        image.image = .testCat
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.isUserInteractionEnabled = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let selectedImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.image = .nonSelected
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let bestImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = .best
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var onTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupConstrints()
        gestureForMainView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func gestureForMainView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        mainImageView.addGestureRecognizer(gesture)
    }
    
    private func setupViews() {
        addSubview(mainImageView)
        mainImageView.addSubview(selectedImage)
        mainImageView.addSubview(bestImage)
    }
    
    private func setupConstrints() {
        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: topAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            selectedImage.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: -8),
            selectedImage.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: -8),
            
            bestImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            bestImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -11)
        ])
    }
    
    func updateSelectedImage(isSelected: Bool) {
        if isSelected {
            selectedImage.image = .isSelected
        } else {
            selectedImage.image = .nonSelected
        }
    }
    
    func hideBestImage(isHidden: Bool) {
        bestImage.isHidden = isHidden
    }
    
    @objc private func didTap() {
        onTap?()
    }
}
