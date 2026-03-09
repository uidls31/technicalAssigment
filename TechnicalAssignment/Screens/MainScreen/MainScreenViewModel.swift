import Foundation

protocol MainScreenViewModelProtocol: AnyObject {
    var photoLibraryService: PhotoLibraryServiceProtocol { get set }
    var storageInfoText: String { get }
    var mediaInfoText: String { get }
    var videoInfoText: String { get }
    var progressValue: Float { get }
    var progressText: String { get }
    var onDataStorageUpdated: (() -> Void)? { get set }
    var onDataMediaInfoText: (() -> Void)? { get set }
    func getStorageInfo()
    func getMediaInfo()
}

class MainScreenViewModel: MainScreenViewModelProtocol {
    
    private let storageService: StorageServiceProtocol
    var photoLibraryService: PhotoLibraryServiceProtocol
    
    var storageInfoText: String = ""
    
    var videoInfoText: String = ""
    var mediaInfoText: String = ""
    
    var progressValue: Float = 0.0
    var progressText: String = ""
    
    var onDataStorageUpdated: (() -> Void)?
    var onDataMediaInfoText: (() -> Void)?
    
    init(storageService: StorageServiceProtocol,
         photoLibraryService: PhotoLibraryServiceProtocol) {
        self.storageService = storageService
        self.photoLibraryService = photoLibraryService
    }
    
    func getStorageInfo() {
        if let info = storageService.getStorageInfo() {
            self.storageInfoText = "\(info.usedSpace) of \(info.totalSpace)"
            self.progressValue = info.usedPercentage
            self.progressText = String(format: "%.0f%%", info.usedPercentage * 100)
            self.onDataStorageUpdated?()
        }
    }
    
    func getMediaInfo() {
        photoLibraryService.calculateBreakdown { [weak self] breakdown in
            guard let self = self else { return }
            
            let videoStats = breakdown.videoStats
            self.videoInfoText = "\(videoStats.count) Videos • \(videoStats.formattedSize)"
            
            let photoStats = breakdown.photoStats
            self.mediaInfoText = "\(photoStats.count) Photos • \(photoStats.formattedSize)"
            
            self.onDataMediaInfoText?()
        }
    }
    
    func requestAccess() {
        photoLibraryService.requestAccess { [weak self] isGranted in
            if isGranted { self?.getMediaInfo() }
        }
    }
}
