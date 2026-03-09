import Foundation

protocol MediaListViewModelProtocol: AnyObject {
    var itemsMediaList: [MediaListModel] { get }
    func numberOfRowsInSection() -> Int
    func loadData()
}

class MediaListViewModel: MediaListViewModelProtocol {
    
    var itemsMediaList: [MediaListModel] = []
    var onUpdateData: (() -> Void)?
    
    private let mediaListService: MediaListServiceProtocol
    
    init(mediaListService: MediaListServiceProtocol) {
        self.mediaListService = mediaListService
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(countsDidUpdate),
            name: .photoLibraryCountsDidUpdate,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func countsDidUpdate() {
        loadData()
        onUpdateData?()
    }
    
    func numberOfRowsInSection() -> Int {
        itemsMediaList.count
    }
    
    func loadData() {
        itemsMediaList = mediaListService.setupModelsForMediaList()
    }
}
