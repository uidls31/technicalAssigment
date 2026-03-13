import UIKit

protocol GroupAlbumViewModelProtocol: AnyObject {
    var titleGroup: String { get }
    var onUpdateData: (() -> Void)? { get set }
    var onItemUpdated: ((Int) -> Void)? { get set }
    var onDeleteButtonUpdate: (() -> Void)? { get set }
    var groups: [[GroupAlbumModel]] { get set }
    var deleteButtonTitle: String { get }
    var isDeleteButtonEnabled: Bool { get }
    func loadData()
    func numberOfRows() -> Int
    func requestImage(for id: String, completion: @escaping (UIImage?) -> Void)
    func deleteSelectedItems()
    func toggleSelectAllInGroup(groupIndex: Int)
    func calculateTotalSize(completion: @escaping (Int64) -> Void)
    func configure(_ cell: GroupAlbumCollectionViewCell, at index: Int)
}

class GroupAlbumViewModel: GroupAlbumViewModelProtocol {
    
    let groupAlbumType: GroupAlbum
    private let photoService: PhotoLibraryServiceProtocol
    var groups: [[GroupAlbumModel]] = []
    var onUpdateData: (() -> Void)?
    var onItemUpdated: ((Int) -> Void)?
    var onDeleteButtonUpdate: (() -> Void)?
    var deleteButtonTitle: String = "Delete 0 items"
    var isDeleteButtonEnabled: Bool = false
    
    
    init(groupAlbumType: GroupAlbum,
         photoService: PhotoLibraryServiceProtocol) {
        self.groupAlbumType = groupAlbumType
        self.photoService = photoService
    }
    
    func loadData() {
        photoService.fetchGroupedItems(for: groupAlbumType) { [weak self] items in
            guard let self else { return }
            groups = items
            updateDeleteButtonState()
            onUpdateData?()
        }
    }
    
    func requestImage(for id: String, completion: @escaping (UIImage?) -> Void) {
        photoService.requestImage(by: id, targetSize: CGSize(width: 200, height: 200), completion: completion)
    }
    
    func calculateTotalSize(completion: @escaping (Int64) -> Void) {
        photoService.calculateGroupTotalSize(for: groupAlbumType, completion: completion)
    }
    
    func toggleSelection(groupIndex: Int, photoIndex: Int) {
        guard groupIndex < groups.count, photoIndex < groups[groupIndex].count else { return }
        groups[groupIndex][photoIndex].isSelected.toggle()
        onItemUpdated?(groupIndex)
        updateDeleteButtonState()
    }
    
    func toggleSelectAllInGroup(groupIndex: Int) {
        guard groupIndex < groups.count else { return }
        
        let currentGroup = groups[groupIndex]
        let allAreSelected = currentGroup.allSatisfy { $0.isSelected }
        let targetState = !allAreSelected
        
        for i in 0..<groups[groupIndex].count {
            groups[groupIndex][i].isSelected = targetState
        }
        onItemUpdated?(groupIndex)
        updateDeleteButtonState()
    }
    
    func deleteSelectedItems() {
        var idsToDelete: [String] = []
        
        for group in groups {
            for item in group where item.isSelected {
                idsToDelete.append(item.id)
            }
        }
        
        guard !idsToDelete.isEmpty else { return }
        
        photoService.deleteAssets(with: idsToDelete) { [weak self] success in
            if success {
                self?.loadData()
            }
        }
    }
    
    private func updateDeleteButtonState() {
        let count = groups.flatMap { $0 }.filter { $0.isSelected }.count
        
        if count == 0 {
            deleteButtonTitle = "Delete"
            isDeleteButtonEnabled = false
        } else {
            let suffix = count == 1 ? "item" : "items"
            deleteButtonTitle = "Delete \(count) \(suffix)"
            isDeleteButtonEnabled = true
        }
        
        onDeleteButtonUpdate?()
    }
    
    func numberOfRows() -> Int {
        return groups.count
    }
    
    var titleGroup: String {
        switch groupAlbumType {
        case .similarVideos:
            return "Similar Videos"
        case .duplicatePhotos:
            return "Duplicate Photos"
        case .similarPhotos:
            return "Similar Photos"
        }
    }
    
    func configure(_ cell: GroupAlbumCollectionViewCell, at index: Int) {
        guard index < groups.count else { return }
        let pair = groups[index]
        
        guard pair.count >= 2 else { return }
        
        let leftItem = pair[0]
        let rightItem = pair[1]
        let leftId = leftItem.id
        let rightId = rightItem.id
        cell.countingDuplicateLabel.text = "2 Duplicates"
        
        let isAllSelected = pair.allSatisfy { $0.isSelected }
        UIView.performWithoutAnimation {
            cell.selectedAllButton.setTitle(isAllSelected ? "Deselect All" : "Select All", for: .normal)
            cell.selectedAllButton.layoutIfNeeded()
        }
        
        cell.leftView.currentId = leftId
        cell.leftView.updateSelectedImage(isSelected: leftItem.isSelected)
        cell.leftView.hideBestImage(isHidden: false)
        

        
        self.requestImage(for: leftItem.id) { [weak cell] image in
            guard cell?.leftView.currentId == leftId else { return }
            cell?.leftView.mainImageView.image = image
        }
        
        cell.rightView.currentId = rightId
        cell.rightView.updateSelectedImage(isSelected: rightItem.isSelected)
        cell.rightView.hideBestImage(isHidden: true)
        
        self.requestImage(for: rightId) { [weak cell] image in
            guard cell?.rightView.currentId == rightId else { return }
            cell?.rightView.mainImageView.image = image
        }
        
        cell.leftView.onTap = { [weak self] in
            self?.toggleSelection(groupIndex: index, photoIndex: 0)
        }
        
        cell.rightView.onTap = { [weak self] in
            self?.toggleSelection(groupIndex: index, photoIndex: 1)
        }
        
        cell.onDidTapSelectedButton = { [weak self] in
            self?.toggleSelectAllInGroup(groupIndex: index)
        }
    }
}
