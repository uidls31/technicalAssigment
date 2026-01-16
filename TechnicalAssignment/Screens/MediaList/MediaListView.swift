import UIKit

protocol MediaListViewProtocol: AnyObject {
    var navigationBarMediaList: CustomNavigationBar { get set }
}

class MediaListView: UIView, MediaListViewProtocol {
    
    var navigationBarMediaList: CustomNavigationBar = {
        let navBar = CustomNavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.backButton.isHidden = false
        return navBar
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
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            navigationBarMediaList.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            navigationBarMediaList.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            navigationBarMediaList.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            navigationBarMediaList.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.06)
        ])
    }
}
