import UIKit

class CustomNavigationBar: UIView {
    
    var buttonAction: (() -> Void)?
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(.iconBack, for: .normal)
        button.contentMode = .scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
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
        addSubview(containerView)
        containerView.addSubview(backButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            backButton.heightAnchor.constraint(equalTo: containerView.heightAnchor /*UIScreen.main.isSmallScreen ? 0.32 : 0.4*/),
            backButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
//            backButton.widthAnchor.constraint(equalTo: containerView.heightAnchor, constant: 0.15),
            backButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, /*constant: UIScreen.main.isSmallScreen ? 0 : 10*/)
        ])
    }
    
    @objc func backButtonTapped() {
        buttonAction?()
    }
    
    func setBackButtonAction(_ action: (() -> Void)?) {
        buttonAction = action
    }
}
