import UIKit

struct MediaListModel {
    let image: UIImage
    let title: String
    let countingItems: Int
    let action: MediaListType
}

enum MediaListType {
    case duplicatePhoto
    case similarPhotos
    case screenshots
    case livePhotos
    case screenRecording
    case similarVideos
}
