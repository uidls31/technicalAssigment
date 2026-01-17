import UIKit

protocol SmartAlbumViewModelProtocol: AnyObject {
    var title: String { get }
    var isAllSelected: Bool { get }
    var itemsSmartAlubm: [SmartAlbumModel]  { get }
    var onUpdateData: (() -> Void)? { get set }
    var onItemUpdated: ((Int) -> Void)? { get set }
    func loadData()
    func toggleSelection(at index: Int)
    func toggleSelectAll()
    func numberOfRowsInSection() -> Int
    func requestImage(at index: Int, completion: @escaping (UIImage?) -> Void)
    func load()
}

class SmartAlbumViewModel: SmartAlbumViewModelProtocol {

    var itemsSmartAlubm: [SmartAlbumModel] = []
    private let albumType: SmartAlbumType
    private let photoService: PhotoLibraryServiceProtocol
    
    
    var onUpdateData: (() -> Void)?
    var onItemUpdated: ((Int) -> Void)?
    
    init(albumType: SmartAlbumType,
         photoService: PhotoLibraryServiceProtocol) {
        self.albumType = albumType
        self.photoService = photoService
    }
    
    func load() {
        photoService.requestAccess { [weak self] granted in
            guard let self = self else { return }
            if granted {
                self.loadData()
            } else {
                print("Access denied")
            }
        }
    }
    
    
    
    func requestImage(at index: Int, completion: @escaping (UIImage?) -> Void) {
            guard index < itemsSmartAlubm.count else { return }
            
            let id = itemsSmartAlubm[index].id
            
            // Мы просим сервис найти картинку по строковому ID
            photoService.requestImage(by: id, targetSize: CGSize(width: 200, height: 200), completion: completion)
        }
    
    func loadData() {
        itemsSmartAlubm = photoService.fetchItems(for: albumType)
        onUpdateData?()
    }
    
    func toggleSelection(at index: Int) {
        itemsSmartAlubm[index].isSelected.toggle()
        onItemUpdated?(index)
    }
    
    var isAllSelected: Bool {
        return !itemsSmartAlubm.isEmpty && itemsSmartAlubm.allSatisfy { $0.isSelected }
    }
    
    func toggleSelectAll() {
        if isAllSelected {
            for i in 0..<itemsSmartAlubm.count { itemsSmartAlubm[i].isSelected = false }
        } else {
            for i in 0..<itemsSmartAlubm.count { itemsSmartAlubm[i].isSelected = true }
        }
        onUpdateData?()
    }
    
    func numberOfRowsInSection() -> Int {
        itemsSmartAlubm.count
    }
    
    
    var title: String {
        switch albumType {
        case .screenshots:
            return "Screen Photos"
        case .livePhotos:
            return "Live Photos"
        case .screenRecordings:
            return "Screen Recordings"
        }
    }
}
