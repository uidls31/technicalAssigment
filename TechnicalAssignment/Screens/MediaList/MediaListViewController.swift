import UIKit

protocol MediaListViewControllerOutputBack: AnyObject {
    func back()
}

protocol MediaListViewControllerOutput: AnyObject {
    func goToSmartAlbum(_ type: SmartAlbumType)
}

protocol MediaListViewControllerOutputToGroupAlbum: AnyObject {
    func goToGroupAlbum(_ type: GroupAlbum)
}

class MediaListViewController: UIViewController {
    
    let customViewMediaList: MediaListViewProtocol
    let viewModelMediaList: MediaListViewModelProtocol
    weak var outputBack: MediaListViewControllerOutputBack?
    weak var output: MediaListViewControllerOutput?
    weak var outputToGroupAlbum: MediaListViewControllerOutputToGroupAlbum?
    
    init(customViewMediaList: MediaListViewProtocol,
         outputBack: MediaListViewControllerOutputBack?,
         viewModelMediaList: MediaListViewModelProtocol,
         output: MediaListViewControllerOutput?,
         outputToGroupAlbum: MediaListViewControllerOutputToGroupAlbum?) {
        self.customViewMediaList = customViewMediaList
        self.outputBack = outputBack
        self.viewModelMediaList = viewModelMediaList
        self.output = output
        self.outputToGroupAlbum = outputToGroupAlbum
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = customViewMediaList as? UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMediaCollectionView()
        setupActions()
        updateDataAndReload()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCountsUpdate),
            name: .photoLibraryCountsDidUpdate,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleCountsUpdate() {
        updateDataAndReload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateDataAndReload()
    }
    
    
    private func setupActions() {
        customViewMediaList.navigationBarMediaList.setBackButtonAction {
            self.outputBack?.back()
        }
    }
    
    private func setupMediaCollectionView() {
        customViewMediaList.mediaCollectionView.dataSource = self
        customViewMediaList.mediaCollectionView.delegate = self
    }
    
    private func updateDataAndReload() {
        viewModelMediaList.loadData()
        DispatchQueue.main.async {
            self.customViewMediaList.mediaCollectionView.reloadData()
        }
    }
    
    
}

extension MediaListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModelMediaList.numberOfRowsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaListCollectionCell.identifier, for: indexPath) as! MediaListCollectionCell
        cell.configure(with: viewModelMediaList.itemsMediaList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = collectionView.bounds.width
        let spacingBetweenCells: CGFloat = 8
        let width = (totalWidth - spacingBetweenCells) / 2
        let height = width * 0.75
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let items = viewModelMediaList.itemsMediaList[indexPath.row]
        
        switch items.action {
        case .duplicatePhoto:
            outputToGroupAlbum?.goToGroupAlbum(.duplicatePhotos)
        case .similarPhotos:
            outputToGroupAlbum?.goToGroupAlbum(.similarPhotos)
        case .screenshots:
            output?.goToSmartAlbum(.screenshots)
        case .livePhotos:
            output?.goToSmartAlbum(.livePhotos)
        case .screenRecording:
            output?.goToSmartAlbum(.screenRecordings)
        case .similarVideos:
            outputToGroupAlbum?.goToGroupAlbum(.similarVideos)
        }
    }
}
