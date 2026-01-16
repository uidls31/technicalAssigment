import Photos
import UIKit

protocol PhotoLibraryServiceProtocol: AnyObject {
    func requestAccess(completion: @escaping (Bool) -> Void)
    func calculateBreakdown(completion: @escaping (PhotoLibraryService.LibraryBreakdown) -> Void)
    func getSmartAlbumCount(type: SmartAlbumType) -> Int
    func requestAccessWithSmartDelay(completion: @escaping (Bool) -> Void)
}

class PhotoLibraryService: PhotoLibraryServiceProtocol {
    
    struct CategoryStats {
        let count: Int
        let sizeBytes: Int64
        
        var formattedSize: String {
            return ByteCountFormatter.string(fromByteCount: sizeBytes, countStyle: .file)
        }
    }
    
    struct LibraryBreakdown {
        let videoStats: CategoryStats
        let photoStats: CategoryStats
    }
    
    
    func requestAccessWithSmartDelay(completion: @escaping (Bool) -> Void) {
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            
            if status == .notDetermined {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                    self?.requestAccess(completion: completion)
                }
            } else {
                requestAccess(completion: completion)
            }
        }
    
    func requestAccess(completion: @escaping (Bool) -> Void) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                DispatchQueue.main.async {
                    completion(status == .authorized || status == .limited)
                }
            }
        }
    
    func calculateBreakdown(completion: @escaping (LibraryBreakdown) -> Void) {
        
        guard PHPhotoLibrary.authorizationStatus(for: .readWrite) == .authorized else {
            let empty = CategoryStats(count: 0, sizeBytes: 0)
            completion(LibraryBreakdown(videoStats: empty, photoStats: empty))
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let fetchOptions = PHFetchOptions()
            let allAssets = PHAsset.fetchAssets(with: fetchOptions)
            
            var videoCount = 0
            var videoSize: Int64 = 0
            
            var photoCount = 0
            var photoSize: Int64 = 0
            
            allAssets.enumerateObjects { asset, _, _ in
                
                var assetSize: Int64 = 0
                let resources = PHAssetResource.assetResources(for: asset)
                if let resource = resources.first,
                   let unsignedSize = resource.value(forKey: "fileSize") as? CLong {
                    assetSize = Int64(unsignedSize)
                }
                
                if asset.mediaType == .video {
                    videoCount += 1
                    videoSize += assetSize
                } else if asset.mediaType == .image {
                    photoCount += 1
                    photoSize += assetSize
                }
            }
            
            let result = LibraryBreakdown(
                videoStats: CategoryStats(count: videoCount, sizeBytes: videoSize),
                photoStats: CategoryStats(count: photoCount, sizeBytes: photoSize)
            )
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func getSmartAlbumCount(type: SmartAlbumType) -> Int {
            let assetSubtype: PHAssetCollectionSubtype
            
            switch type {
            case .screenshots:
                assetSubtype = .smartAlbumScreenshots
            case .livePhotos:
                assetSubtype = .smartAlbumLivePhotos
            case .screenRecordings:
                assetSubtype = .smartAlbumScreenRecordings
            }
            
            let collection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: assetSubtype, options: nil)
            
            if let first = collection.firstObject {
                let count = PHAsset.fetchAssets(in: first, options: nil).count
                return count
            }
            return 0
        }
}
