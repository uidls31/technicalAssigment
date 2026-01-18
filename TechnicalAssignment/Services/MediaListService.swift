import UIKit

protocol MediaListServiceProtocol: AnyObject {
    func setupModelsForMediaList() -> [MediaListModel]
}

class MediaListService: MediaListServiceProtocol {
    
    let photoLibraryService: PhotoLibraryServiceProtocol
    
    init(photoLibraryService: PhotoLibraryServiceProtocol) {
        self.photoLibraryService = photoLibraryService
    }
    
    func setupModelsForMediaList() -> [MediaListModel] {
        return [
            MediaListModel.init(image: .iconDuplicateImages, title: "Duplicate Photos", countingItems: 0, action: .duplicatePhoto),
            MediaListModel.init(image: .iconSimilarPhotos, title: "Similar Photos", countingItems: 0, action: .similarPhotos),
            MediaListModel.init(image: .iconScreenshots, title: "Screenshots", countingItems: photoLibraryService.getSmartAlbumCount(type: .screenshots), action: .screenshots),
            MediaListModel.init(image: .iconLivePhotos, title: "Live Photos", countingItems: photoLibraryService.getSmartAlbumCount(type: .livePhotos), action: .livePhotos),
            MediaListModel.init(image: .iconScreenRecordings, title: "Screen Recordings", countingItems: photoLibraryService.getSmartAlbumCount(type: .screenRecordings), action: .screenRecording),
            MediaListModel.init(image: .iconSimilarVideos, title: "Similar Videos", countingItems: 0, action: .similarVideos)
        ]
    }
}


enum SmartAlbumType {
    case screenshots
    case livePhotos
    case screenRecordings
}

enum GroupAlbum {
    case similarVideos
    case duplicatePhotos
    case similarPhotos
}
