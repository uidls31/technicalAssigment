import UIKit

protocol MainScreenViewControllerProtocol: AnyObject {
    func goToMediaList()
}

class MainScreenViewController: UIViewController {
    
    let customViewMainScreen: MainScreenViewProtocol
    let viewModelMainScreen: MainScreenViewModelProtocol
    
    weak var outputToMediaList: MainScreenViewControllerProtocol?
    
    init(customViewMainScreen: MainScreenViewProtocol,
         viewModelMainScreen: MainScreenViewModelProtocol,
         outputToMediaList: MainScreenViewControllerProtocol?) {
        self.customViewMainScreen = customViewMainScreen
        self.viewModelMainScreen = viewModelMainScreen
        self.outputToMediaList = outputToMediaList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = customViewMainScreen as? UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        setupBindings()
        viewModelMainScreen.getStorageInfo()
        requestAndLoadMedia()
    }
    
    private func requestAndLoadMedia() {
        updateProgress()
        viewModelMainScreen.photoLibraryService.requestAccessWithSmartDelay { [weak self] isGranted in
            guard let self = self, isGranted else { return }
            self.viewModelMainScreen.getMediaInfo()
            
            DispatchQueue.main.async {
                self.customViewMainScreen.updateLocks(isLocked: isGranted)
            }
        }
    }
    
    private func updateProgress() {
        DispatchQueue.main.async {
            self.customViewMainScreen.updateProgress(
                value: self.viewModelMainScreen.progressValue,
                text: self.viewModelMainScreen.progressText
            )
        }
    }
    
    private func setupBindings() {
        viewModelMainScreen.onDataStorageUpdated = { [weak self] in
            DispatchQueue.main.async {
                guard let self else { return }
                self.customViewMainScreen.configureTextStorage(with: self.viewModelMainScreen.storageInfoText)
            }
        }
        viewModelMainScreen.onDataMediaInfoText = { [weak self] in
            DispatchQueue.main.async {
                guard let self else { return }
                self.customViewMainScreen.configureTextMedia(with: self.viewModelMainScreen.mediaInfoText)
                self.customViewMainScreen.configureTextVideoCompressor(with: self.viewModelMainScreen.videoInfoText)
            }
        }
    }
    
    private func setupActions() {
        customViewMainScreen.onDidTapOnTargetToMediaList = { [weak self] in
            guard let self else { return }
            outputToMediaList?.goToMediaList()
        }
    }
    
}
