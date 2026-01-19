import UIKit

protocol GroupAlbumViewControllerOutputBack: AnyObject {
    func goGroupBack()
}

class GroupAlbumViewController: UIViewController {
    
    let customGroupAlbumView: GroupAlbumViewProtocol
    let viewModelGroupAlbum: GroupAlbumViewModelProtocol
    weak var outputBackGroup: GroupAlbumViewControllerOutputBack?
    
    init(customGroupAlbumView: GroupAlbumViewProtocol,
         outputBackGroup: GroupAlbumViewControllerOutputBack?,
         viewModelGroupAlbum: GroupAlbumViewModelProtocol) {
        self.customGroupAlbumView = customGroupAlbumView
        self.outputBackGroup = outputBackGroup
        self.viewModelGroupAlbum = viewModelGroupAlbum
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = customGroupAlbumView as? UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupActions()
        setupBindings()
        viewModelGroupAlbum.loadData()
    }
    
    private func setupActions() {
        customGroupAlbumView.navigationBarGroupAlbum.setBackButtonAction {
            self.outputBackGroup?.goGroupBack()
        }
        customGroupAlbumView.onDidTapDeleteButton = { [weak self] in
            guard let self else { return }
            viewModelGroupAlbum.deleteSelectedItems()
        }
    }
    
    private func setupBindings() {
        customGroupAlbumView.headerGroupLabel.text = viewModelGroupAlbum.titleGroup
        
        viewModelGroupAlbum.onUpdateData = { [weak self] in
            DispatchQueue.main.async {
                self?.customGroupAlbumView.groupAlbumCollectionView.reloadData()
                self?.updateHeaderInfo()
            }
        }
        
        viewModelGroupAlbum.onItemUpdated = { [weak self] index in
            guard let self = self else { return }
            let indexPath = IndexPath(row: index, section: 0)
            
            if let cell = self.customGroupAlbumView.groupAlbumCollectionView.cellForItem(at: indexPath) as? GroupAlbumCollectionViewCell {
                viewModelGroupAlbum.configure(cell, at: index)
            }
        }
        
        viewModelGroupAlbum.onDeleteButtonUpdate = { [weak self] in
            guard let self else { return }
            customGroupAlbumView.deleteButton.setTitle(viewModelGroupAlbum.deleteButtonTitle, for: .normal)
        }
        
    }
    
    private func setupCollectionView() {
        customGroupAlbumView.groupAlbumCollectionView.delegate = self
        customGroupAlbumView.groupAlbumCollectionView.dataSource = self
    }
    
    private func updateHeaderInfo() {
        viewModelGroupAlbum.calculateTotalSize { [weak self] sizeBytes in
            let formattedSize = ByteCountFormatter.string(fromByteCount: sizeBytes, countStyle: .file)
            self?.customGroupAlbumView.countingMaterialLabel.text = formattedSize
        }
        
        let totalCount = viewModelGroupAlbum.groups.flatMap { $0 }.count
        let suffix = totalCount == 1 ? "file" : "files"
        customGroupAlbumView.cameraCountingLabel.text = "\(totalCount) \(suffix)"
    }
    
}

extension GroupAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModelGroupAlbum.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupAlbumCollectionViewCell.identifier, for: indexPath) as! GroupAlbumCollectionViewCell
        viewModelGroupAlbum.configure(cell, at: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = collectionView.frame.width - 32
        let photoWidth = (totalWidth - 8) / 2
        let photoHeight = photoWidth * 1.25
        let headerHeight: CGFloat = 30 + 15
        
        let totalHeight = photoHeight + headerHeight
        
        return CGSize(width: collectionView.frame.width, height: totalHeight)
    }
    
}
