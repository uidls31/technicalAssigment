import UIKit

protocol MainScreenViewProtocol: AnyObject {
    func configureTextStorage(with text: String)
    func configureTextVideoCompressor(with text: String)
    func configureTextMedia(with text: String)
    func updateLocks(isLocked: Bool)
    func updateProgress(value: Float, text: String)
    var onDidTapOnTargetToMediaList: (() -> Void)? { get set }
}

class MainScreenView: UIView, MainScreenViewProtocol {
    
    
    let mainStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 19
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var customProgress: CustomProgressView = {
        let view = CustomProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let whiteContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerCurve = .continuous
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 10
        view.layer.masksToBounds = false
        return view
    }()
    
    let stackViewForLabelsMain: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let storageLabel: UILabel = {
        let label = UILabel()
        let size = CGFloat.dynamicFontSize(baseFontSize: 16)
        label.text = "iPhone Storage"
        label.textColor = .anotherWhite
        label.font = UIFont.systemFont(ofSize: size, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stackViewForVideoAndCameraImage: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let stackViewForVideoAndMediaImage: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let cameraImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .cameraMainScreen
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let mediaImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .imageMainScreen
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let videoCompressorLabel: UILabel = {
        let label = UILabel()
        let size = CGFloat.dynamicFontSize(baseFontSize: 20)
        label.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        label.textColor = .black
        label.text = "Video Compressor"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let mediaLabel: UILabel = {
        let label = UILabel()
        let size = CGFloat.dynamicFontSize(baseFontSize: 20)
        label.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        label.textColor = .black
        label.text = "Media"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let videoStorageLabel: UILabel = {
        let label = UILabel()
        let size = CGFloat.dynamicFontSize(baseFontSize: 16)
        label.font = UIFont.systemFont(ofSize: size, weight: .regular)
        label.textColor = .newGrayMainScreen
        label.text = "0 Videos • Zero KB"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let mediaStorageLabel: UILabel = {
        let label = UILabel()
        let size = CGFloat.dynamicFontSize(baseFontSize: 16)
        label.font = UIFont.systemFont(ofSize: size, weight: .regular)
        label.textColor = .newGrayMainScreen
        label.text = "0 Media • Zero KB"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let firstImageMainScreen: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = .firstImageMainScreen
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let firstLock: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = .lockIcon
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let secondLock: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = .lockIcon
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let viewAllLabel: UILabel = {
        let label = UILabel()
        let size = CGFloat.dynamicFontSize(baseFontSize: 16)
        label.font = UIFont.systemFont(ofSize: size, weight: .regular)
        label.textColor = .newGrayMainScreen
        label.text = "View all"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let vectorMainScreen: UIImageView = {
        let image = UIImageView()
        image.image = .vectorMainScreen
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let stackViewForAllAndVector: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let catImage: UIImageView = {
        let image = UIImageView()
        image.image = .cat
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let giraffeImage: UIImageView = {
        let image = UIImageView()
        image.image = .giraffe
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let stackViewForCatAndGiraffe: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = UIScreen.main.isProMax ? 24 : 8
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var countingLabel: UILabel = {
        let label = UILabel()
        let size = CGFloat.dynamicFontSize(baseFontSize: 16)
        label.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        label.textColor = .anotherWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let containerTargetToMediaList: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .mainScreenBackk
        setupViews()
        containerTargetToMediaList.addGestureRecognizer(createGestureRecognizer())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    private func createGestureRecognizer() -> UITapGestureRecognizer {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnTargetToMediaList))
        return tapGestureRecognizer
    }
    
    var onDidTapOnTargetToMediaList: (() -> Void)?
    
    @objc private func didTapOnTargetToMediaList() {
        onDidTapOnTargetToMediaList?()
    }
    
    private func setupViews() {
        addSubview(mainStack)
        addSubview(whiteContainerView)
        addSubview(stackViewForLabelsMain)
        mainStack.addArrangedSubview(stackViewForLabelsMain)
        stackViewForLabelsMain.addArrangedSubview(storageLabel)
        stackViewForLabelsMain.addArrangedSubview(countingLabel)
        mainStack.addArrangedSubview(customProgress)
        whiteContainerView.addSubview(stackViewForVideoAndCameraImage)
        stackViewForVideoAndCameraImage.addArrangedSubview(cameraImage)
        stackViewForVideoAndCameraImage.addArrangedSubview(videoCompressorLabel)
        whiteContainerView.addSubview(videoStorageLabel)
        whiteContainerView.addSubview(firstImageMainScreen)
        whiteContainerView.addSubview(stackViewForVideoAndMediaImage)
        stackViewForVideoAndMediaImage.addArrangedSubview(mediaImage)
        stackViewForVideoAndMediaImage.addArrangedSubview(mediaLabel)
        whiteContainerView.addSubview(mediaStorageLabel)
        whiteContainerView.addSubview(firstLock)
        whiteContainerView.addSubview(secondLock)
        whiteContainerView.addSubview(stackViewForAllAndVector)
        stackViewForAllAndVector.addArrangedSubview(viewAllLabel)
        stackViewForAllAndVector.addArrangedSubview(vectorMainScreen)
        whiteContainerView.addSubview(stackViewForCatAndGiraffe)
        stackViewForCatAndGiraffe.addArrangedSubview(catImage)
        stackViewForCatAndGiraffe.addArrangedSubview(giraffeImage)
        whiteContainerView.addSubview(containerTargetToMediaList)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            mainStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 13),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            mainStack.heightAnchor.constraint(equalTo: heightAnchor, multiplier: UIScreen.main.isSmallScreen ? 0.25: 0.2),
            
            
            whiteContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            whiteContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            whiteContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            whiteContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            customProgress.heightAnchor.constraint(equalTo: mainStack.heightAnchor, multiplier: UIScreen.main.isSmallScreen ? 0.8 : 0.9),
            customProgress.widthAnchor.constraint(equalTo: mainStack.heightAnchor, multiplier: UIScreen.main.isSmallScreen ? 0.8 : 0.9),
            
            
            stackViewForVideoAndCameraImage.topAnchor.constraint(equalTo: whiteContainerView.topAnchor, constant: 32),
            stackViewForVideoAndCameraImage.leadingAnchor.constraint(equalTo: whiteContainerView.leadingAnchor, constant: 24),
            
            videoStorageLabel.topAnchor.constraint(equalTo: stackViewForVideoAndCameraImage.bottomAnchor, constant: 8),
            videoStorageLabel.leadingAnchor.constraint(equalTo: whiteContainerView.leadingAnchor, constant: 24),
            
            firstImageMainScreen.heightAnchor.constraint(equalTo: whiteContainerView.heightAnchor, multiplier: 0.28),
            firstImageMainScreen.topAnchor.constraint(equalTo: videoStorageLabel.bottomAnchor, constant: 14),
            firstImageMainScreen.leadingAnchor.constraint(equalTo: whiteContainerView.leadingAnchor, constant: 28),
            firstImageMainScreen.trailingAnchor.constraint(equalTo: whiteContainerView.trailingAnchor, constant: -28),
            
            stackViewForVideoAndMediaImage.topAnchor.constraint(equalTo: firstImageMainScreen.bottomAnchor, constant: 24),
            stackViewForVideoAndMediaImage.leadingAnchor.constraint(equalTo: whiteContainerView.leadingAnchor, constant: 24),
            
            mediaStorageLabel.topAnchor.constraint(equalTo: stackViewForVideoAndMediaImage.bottomAnchor, constant: 8),
            mediaStorageLabel.leadingAnchor.constraint(equalTo: whiteContainerView.leadingAnchor, constant: 24),
            
            firstLock.centerYAnchor.constraint(equalTo: videoCompressorLabel.centerYAnchor),
            firstLock.trailingAnchor.constraint(equalTo: whiteContainerView.trailingAnchor, constant: -24),
            
            secondLock.centerYAnchor.constraint(equalTo: mediaLabel.centerYAnchor),
            secondLock.trailingAnchor.constraint(equalTo: whiteContainerView.trailingAnchor, constant: -24),
            
            stackViewForAllAndVector.centerYAnchor.constraint(equalTo: mediaStorageLabel.centerYAnchor),
            stackViewForAllAndVector.trailingAnchor.constraint(equalTo: whiteContainerView.trailingAnchor, constant: -24),
            
            
            stackViewForCatAndGiraffe.centerXAnchor.constraint(equalTo: whiteContainerView.centerXAnchor),
            stackViewForCatAndGiraffe.topAnchor.constraint(equalTo: stackViewForAllAndVector.bottomAnchor, constant: UIScreen.main.isSmallScreen ? 11 : 21),
            stackViewForCatAndGiraffe.heightAnchor.constraint(equalTo: whiteContainerView.heightAnchor, multiplier: 0.3),
            
            containerTargetToMediaList.topAnchor.constraint(equalTo: stackViewForVideoAndMediaImage.topAnchor),
            containerTargetToMediaList.leadingAnchor.constraint(equalTo: whiteContainerView.leadingAnchor),
            containerTargetToMediaList.trailingAnchor.constraint(equalTo: whiteContainerView.trailingAnchor),
            containerTargetToMediaList.bottomAnchor.constraint(equalTo: stackViewForCatAndGiraffe.bottomAnchor)
        ])
    }
    
    func configureTextStorage(with text: String) {
        countingLabel.text = text
    }
    func configureTextVideoCompressor(with text: String) {
        videoStorageLabel.text = text
    }
    
    func configureTextMedia(with text: String) {
        mediaStorageLabel.text = text
    }
    
    func updateLocks(isLocked: Bool) {
        if isLocked {
            firstLock.isHidden = true
            secondLock.isHidden = true
        } else {
            firstLock.isHidden = false
            secondLock.isHidden = false
        }
    }
    
    func updateProgress(value: Float, text: String) {
        customProgress.setProgress(value: value, text: text)
    }
}
