import Foundation

protocol MediaListViewModelProtocol: AnyObject {
    var itemsMediaList: [MediaListModel] { get }
    func numberOfRowsInSection() -> Int
    func loadData()
}

class MediaListViewModel: MediaListViewModelProtocol {
    
    var itemsMediaList: [MediaListModel] = []
    
    private let mediaListService: MediaListServiceProtocol
    
    init(mediaListService: MediaListServiceProtocol) {
        self.mediaListService = mediaListService
    }
    
    func numberOfRowsInSection() -> Int {
        itemsMediaList.count
    }
    
    func loadData() {
        itemsMediaList = mediaListService.setupModelsForMediaList()
    }
}
