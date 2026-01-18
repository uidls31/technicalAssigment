import UIKit

protocol GroupAlbumViewModelProtocol: AnyObject {
    var titleGroup: String { get }
}

class GroupAlbumViewModel: GroupAlbumViewModelProtocol {
    
    let groupAlbumType: GroupAlbum
    
    init(groupAlbumType: GroupAlbum) {
        self.groupAlbumType = groupAlbumType
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
}
