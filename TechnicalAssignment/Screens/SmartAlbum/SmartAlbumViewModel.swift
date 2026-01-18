import UIKit

protocol SmartAlbumViewModelProtocol: AnyObject {
    var title: String { get }
    var isAllSelected: Bool { get }
    var itemsSmartAlubm: [SmartAlbumModel]  { get }
    var onUpdateData: (() -> Void)? { get set }
    var onItemUpdated: ((Int) -> Void)? { get set }
    var albumType: SmartAlbumType { get }
    var totalSizeString: String { get }
    var onDeleteButtonUpdate: (() -> Void)? { get set }
    var deleteButtonTitle: String { get set }
    var isDeleteButtonEnabled: Bool { get set }
    var onSelectButtonUpdate: ((Bool) -> Void)? { get set }
    func loadData()
    func toggleSelection(at index: Int)
    func deselectAll()
    func numberOfRowsInSection() -> Int
    func requestImage(at index: Int, completion: @escaping (UIImage?) -> Void)
    func load()
    func deleteSelectedItems()
}

class SmartAlbumViewModel: SmartAlbumViewModelProtocol {
    
    
    var itemsSmartAlubm: [SmartAlbumModel] = []
    var albumType: SmartAlbumType
    private let photoService: PhotoLibraryServiceProtocol
    var totalSizeString: String = "Calculating"
    var deleteButtonTitle: String = "Delete 0 photos"
    var isDeleteButtonEnabled: Bool = false
    
    
    var onDeleteButtonUpdate: (() -> Void)?
    var onUpdateData: (() -> Void)?
    var onItemUpdated: ((Int) -> Void)?
    var onSelectButtonUpdate: ((Bool) -> Void)?
    
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
        photoService.requestImage(by: id, targetSize: CGSize(width: 200, height: 200), completion: completion)
    }
    
    func loadData() {
        itemsSmartAlubm = photoService.fetchItems(for: albumType)
        onUpdateData?()
        onDeleteButtonUpdate?()
        onSelectButtonUpdate?(isAllSelected)
        photoService.calculateTotalSize(for: albumType) { number in
            self.totalSizeString = ByteCountFormatter.string(fromByteCount: number, countStyle: .file)
            self.onUpdateData?()
            self.updateDeleteButton()
        }
        
    }
    
    func deselectAll() {
        
        let targetState = !isAllSelected
        
        for i in 0..<itemsSmartAlubm.count {
            itemsSmartAlubm[i].isSelected = targetState
        }
        
        updateDeleteButton()
        onSelectButtonUpdate?(targetState)
    }
    
    private func updateDeleteButton() {
        let selectedItems = itemsSmartAlubm.filter { $0.isSelected }
        let count = itemsSmartAlubm.filter { $0.isSelected }.count
        
        if count == 0 {
            deleteButtonTitle = "Delete 0 photos"
            isDeleteButtonEnabled = false
        } else {
            let totalSizeBytes = selectedItems.reduce(0) { result, item in
                return result + photoService.getFileSize(for: item.id)
            }
            let formattedSize = ByteCountFormatter.string(fromByteCount: totalSizeBytes, countStyle: .file)
            
            let suffix = count == 1 ? "photo" : "photos"
            
            deleteButtonTitle = "Delete \(count) \(suffix) (\(formattedSize))"
            isDeleteButtonEnabled = true
        }
        
        onDeleteButtonUpdate?()
    }
    
    func toggleSelection(at index: Int) {
        itemsSmartAlubm[index].isSelected.toggle()
        updateDeleteButton()
        onItemUpdated?(index)
    }
    
    var isAllSelected: Bool {
        return !itemsSmartAlubm.isEmpty && itemsSmartAlubm.allSatisfy { $0.isSelected }
    }
    
    
    func numberOfRowsInSection() -> Int {
        itemsSmartAlubm.count
    }
    
    func deleteSelectedItems() {
        let selectedItems = itemsSmartAlubm.filter({ $0.isSelected }).map { $0.id }
        guard !selectedItems.isEmpty else { return }
        
        photoService.deleteAssets(with: selectedItems) { success in
            if success {
                self.loadData()
            }
        }
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
