import UIKit

class GroupAlbumCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "GroupAlbumCollectionViewCell"
    
    var onDidTapSelectedButton: (() -> Void)?
    
    let leftView: CustomGroupSelectablePhotoView = {
        let view = CustomGroupSelectablePhotoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        view.layer.cornerRadius = 10
        return view
    }()
    
    let rightView: CustomGroupSelectablePhotoView = {
        let view = CustomGroupSelectablePhotoView()
        view.hideBestImage(isHidden: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    let stackViewForViews: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let countingDuplicateLabel: UILabel = {
        let label = UILabel()
        let size = CGFloat.dynamicFontSize(baseFontSize: 16)
        label.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        label.text = "2 Duplicate"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var selectedAllButton: UIButton = {
        let button = UIButton()
        let size = CGFloat.dynamicFontSize(baseFontSize: 16)
        button.setTitle("Selected All", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: size, weight: .medium)
        button.setTitleColor(.newGrayMainScreen, for: .normal)
        button.addTarget(self, action: #selector(didTapSelectedAllButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViews() {
        contentView.addSubview(countingDuplicateLabel)
        contentView.addSubview(selectedAllButton)
        contentView.addSubview(stackViewForViews)
        stackViewForViews.addArrangedSubview(leftView)
        stackViewForViews.addArrangedSubview(rightView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            countingDuplicateLabel.centerYAnchor.constraint(equalTo: selectedAllButton.centerYAnchor),
            countingDuplicateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            
            selectedAllButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            selectedAllButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            stackViewForViews.topAnchor.constraint(equalTo: selectedAllButton.bottomAnchor, constant: 12),
            stackViewForViews.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackViewForViews.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackViewForViews.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
    }
    
    @objc private func didTapSelectedAllButton() {
        onDidTapSelectedButton?()
    }
}
