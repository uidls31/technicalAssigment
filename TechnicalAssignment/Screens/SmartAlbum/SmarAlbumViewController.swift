import UIKit

protocol SmarAlbumViewControllerProtocolOutputBack: AnyObject {
    func goBack()
}

class SmarAlbumViewController: UIViewController {
    
    let customViewSmartAlbum: SmarAlbumViewProtocol
    let viewModelSmartAlbum: SmartAlbumViewModelProtocol
    weak var outputBack: SmarAlbumViewControllerProtocolOutputBack?
    
    init(customViewSmartAlbum: SmarAlbumViewProtocol,
         outputBack: SmarAlbumViewControllerProtocolOutputBack?,
         viewModelSmartAlbum: SmartAlbumViewModelProtocol) {
        self.customViewSmartAlbum = customViewSmartAlbum
        self.outputBack = outputBack
        self.viewModelSmartAlbum = viewModelSmartAlbum
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = customViewSmartAlbum as? UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModelSmartAlbum.load()
        setupCollectionView()
        setupBindings()
        setupActions()
    }
    
    private func setupActions() {
        customViewSmartAlbum.navigationBarSmartView.setBackButtonAction {
            self.outputBack?.goBack()
        }
    }
    
    private func setupBindings() {
        customViewSmartAlbum.headerLabel.text = viewModelSmartAlbum.title
        viewModelSmartAlbum.onUpdateData = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.customViewSmartAlbum.smartAlbumCollectionView.reloadData()
            }
        }
        
        viewModelSmartAlbum.onItemUpdated = { [weak self] index in
            guard let self else { return }
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = self.customViewSmartAlbum.smartAlbumCollectionView.cellForItem(at: indexPath) as? SmarAlbumCollectionViewCell {
                
                let isSelected = self.viewModelSmartAlbum.itemsSmartAlubm[index].isSelected
                
                cell.configure(isSelected: isSelected)
            }
        }
    }
    
    private func setupCollectionView() {
        customViewSmartAlbum.smartAlbumCollectionView.dataSource = self
        customViewSmartAlbum.smartAlbumCollectionView.delegate = self
    }
}

extension SmarAlbumViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModelSmartAlbum.numberOfRowsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmarAlbumCollectionViewCell.identifier, for: indexPath) as! SmarAlbumCollectionViewCell
        guard indexPath.row < viewModelSmartAlbum.itemsSmartAlubm.count else { return cell }
        
        let item = viewModelSmartAlbum.itemsSmartAlubm[indexPath.row]
        cell.configure(isSelected: item.isSelected)
        
        let currentTag = item.id.hashValue
        cell.tag = currentTag
        viewModelSmartAlbum.requestImage(at: indexPath.row) { image in
            if cell.tag == currentTag {
                DispatchQueue.main.async {
                    cell.setImage(image)
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModelSmartAlbum.toggleSelection(at: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = collectionView.bounds.width
        let spacing: CGFloat = 8
        let width = (totalWidth - spacing) / 2
        let height = width * 1.25
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        2
    }
}
