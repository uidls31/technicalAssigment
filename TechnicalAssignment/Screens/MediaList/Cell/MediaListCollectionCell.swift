import UIKit

class MediaListCollectionCell: UICollectionViewCell {
    
    static let identifier = "MediaListCollectionCell"

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
        
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let stackViewForLabels: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let mainLabel: UILabel = {
        let label = UILabel()
        let size = CGFloat.dynamicFontSize(baseFontSize: 16)
        label.font = UIFont.systemFont(ofSize: size, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let itemsLabel: UILabel = {
        let label = UILabel()
        let size = CGFloat.dynamicFontSize(baseFontSize: 14)
        label.font = UIFont.systemFont(ofSize: size, weight: .regular)
        label.textColor = .newGrayMainScreen
        label.text = "1746 Items"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(stackViewForLabels)
        stackViewForLabels.addArrangedSubview(mainLabel)
        stackViewForLabels.addArrangedSubview(itemsLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 13),
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 13),
            
            stackViewForLabels.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20),
            stackViewForLabels.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 13)
        ])
    }
    
    func configure(with model: MediaListModel) {
        iconImageView.image = model.image
        mainLabel.text = model.title
        itemsLabel.text = "\(model.countingItems)"
    }
}
