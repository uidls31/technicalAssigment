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
    }
    
    private func setupActions() {
        customGroupAlbumView.navigationBarGroupAlbum.setBackButtonAction {
            self.outputBackGroup?.goGroupBack()
        }
    }
    
    private func setupBindings() {
        customGroupAlbumView.headerGroupLabel.text = viewModelGroupAlbum.titleGroup
    }
    
    private func setupCollectionView() {
        customGroupAlbumView.groupAlbumCollectionView.delegate = self
        customGroupAlbumView.groupAlbumCollectionView.dataSource = self
    }
}

extension GroupAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupAlbumCollectionViewCell.identifier, for: indexPath) as! GroupAlbumCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        CGSize(width: collectionView.frame.width, height: collectionView.frame.height / 3)
        let totalWidth = collectionView.frame.width - 32
                let photoWidth = (totalWidth - 8) / 2
                let photoHeight = photoWidth * 1.25
                let headerHeight: CGFloat = 30 + 15
                
                let totalHeight = photoHeight + headerHeight
                
                return CGSize(width: collectionView.frame.width, height: totalHeight)
    }
    
}
