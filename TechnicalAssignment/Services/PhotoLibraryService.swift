import Photos
import UIKit

protocol PhotoLibraryServiceProtocol: AnyObject {
    func requestAccess(completion: @escaping (Bool) -> Void)
    func calculateBreakdown(completion: @escaping (PhotoLibraryService.LibraryBreakdown) -> Void)
    func getSmartAlbumCount(type: SmartAlbumType) -> Int
    func requestAccessWithSmartDelay(completion: @escaping (Bool) -> Void)
    func fetchItems(for type: SmartAlbumType) -> [SmartAlbumModel]
    func requestImage(by id: String, targetSize: CGSize, completion: @escaping (UIImage?) -> Void)
    func deleteAssets(with ids: [String], completion: @escaping (Bool) -> Void)
    func calculateTotalSize(for type: SmartAlbumType, completion: @escaping (Int64) -> Void)
    func getFileSize(for id: String) -> Int64
    func fetchGroupedItems(for type: GroupAlbum, completion: @escaping ([[GroupAlbumModel]]) -> Void)
    func getGroupAlbumCount(type: GroupAlbum) -> Int
    func calculateGroupTotalSize(for type: GroupAlbum, completion: @escaping (Int64) -> Void)
}

class PhotoLibraryService: PhotoLibraryServiceProtocol {
    private var assetsCache: [String: PHAsset] = [:]
    private var sizesCache: [String: Int64] = [:]
    private var cachedGroupCounts: [GroupAlbum: Int] = [:]
    private var isCalculating: [GroupAlbum: Bool] = [:]
    private let cacheLock = NSLock()
    
    
    func fetchGroupedItems(for type: GroupAlbum, completion: @escaping ([[GroupAlbumModel]]) -> Void) {
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let mediaType: PHAssetMediaType = (type == .similarVideos) ? .video : .image
            let allAssets = PHAsset.fetchAssets(with: mediaType, options: fetchOptions)
            
            var resultPairs: [[GroupAlbumModel]] = []
            if type == .duplicatePhotos {
                
                var groupedAssets = [String: [PHAsset]]()
                
                allAssets.enumerateObjects { asset, _, _ in
                    if let date = asset.creationDate {
                        let key = "\(Int(date.timeIntervalSince1970))_\(asset.pixelWidth)_\(asset.pixelHeight)"
                        groupedAssets[key, default: []].append(asset)
                    }
                }
                let duplicates = groupedAssets.values.filter { $0.count > 1 }
                
                for group in duplicates {
                    let pairs = self.chunkIntoPairs(assets: group)
                    resultPairs.append(contentsOf: pairs)
                }
            }
            else {
                let timeThreshold: TimeInterval = 1.5
                
                var currentSeries: [PHAsset] = []
                var lastAssetDate: Date?
                
                allAssets.enumerateObjects { asset, _, _ in
                    guard let currentDate = asset.creationDate else { return }
                    
                    if let lastDate = lastAssetDate, abs(currentDate.timeIntervalSince(lastDate)) < timeThreshold {
                        currentSeries.append(asset)
                    } else {
                        if currentSeries.count >= 2 {
                            let pairs = self.chunkIntoPairs(assets: currentSeries)
                            resultPairs.append(contentsOf: pairs)
                        }
                        currentSeries = [asset]
                    }
                    lastAssetDate = currentDate
                }
                
                if currentSeries.count >= 2 {
                    let pairs = self.chunkIntoPairs(assets: currentSeries)
                    resultPairs.append(contentsOf: pairs)
                }
            }
            
            DispatchQueue.main.async {
                completion(resultPairs)
            }
        }
    }
    
    private func chunkIntoPairs(assets: [PHAsset]) -> [[GroupAlbumModel]] {
        var pairs: [[GroupAlbumModel]] = []
        
        for i in stride(from: 0, to: assets.count - 1, by: 2) {
            let asset1 = assets[i]
            let asset2 = assets[i+1]
            cacheLock.lock()
            self.assetsCache[asset1.localIdentifier] = asset1
            self.assetsCache[asset2.localIdentifier] = asset2
            cacheLock.unlock()
            
            let model1 = GroupAlbumModel(id: asset1.localIdentifier, size: 0, isSelected: false)
            let model2 = GroupAlbumModel(id: asset2.localIdentifier, size: 0, isSelected: true)
            
            pairs.append([model1, model2])
        }
        return pairs
    }
    
    func calculateGroupTotalSize(for type: GroupAlbum, completion: @escaping (Int64) -> Void) {
        fetchGroupedItems(for: type) { [weak self] groups in
            guard let self = self else { return }
            
            DispatchQueue.global(qos: .utility).async {
                var totalBytes: Int64 = 0
                let allModels = groups.flatMap { $0 }
                
                for model in allModels {
                    self.cacheLock.lock()
                    let asset = self.assetsCache[model.id]
                    self.cacheLock.unlock()
                    
                    if let asset = asset {
                        let resources = PHAssetResource.assetResources(for: asset)
                        if let resource = resources.first,
                           let unsignedSize = resource.value(forKey: "fileSize") as? CLong {
                            totalBytes += Int64(unsignedSize)
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    completion(totalBytes)
                }
            }
        }
    }
    
    func getGroupAlbumCount(type: GroupAlbum) -> Int {
        if let cached = cachedGroupCounts[type] {
            return cached
        }
        if isCalculating[type] != true {
            isCalculating[type] = true
            fetchGroupedItems(for: type) { [weak self] groups in
                self?.cachedGroupCounts[type] = groups.count
                self?.isCalculating[type] = false
                NotificationCenter.default.post(name: .photoLibraryCountsDidUpdate, object: nil)
            }
        }
        return 0
    }
    
    func fetchItems(for type: SmartAlbumType) -> [SmartAlbumModel] {
        let assetSubtype: PHAssetCollectionSubtype
        
        switch type {
        case .screenshots: assetSubtype = .smartAlbumScreenshots
        case .livePhotos: assetSubtype = .smartAlbumLivePhotos
        case .screenRecordings: assetSubtype = .smartAlbumScreenRecordings
        }
        
        let collection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: assetSubtype, options: nil)
        var items: [SmartAlbumModel] = []
        
        assetsCache.removeAll()
        
        if let firstObject = collection.firstObject {
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let result = PHAsset.fetchAssets(in: firstObject, options: options)
            
            result.enumerateObjects { [weak self] asset, _, _ in
                let id = asset.localIdentifier
                self?.assetsCache[id] = asset
                
                items.append(SmartAlbumModel(id: id, size: 0, isSelected: false))
            }
        }
        return items
    }
    
    func calculateTotalSize(for type: SmartAlbumType, completion: @escaping (Int64) -> Void) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            
            let assetSubtype: PHAssetCollectionSubtype
            switch type {
            case .screenshots: assetSubtype = .smartAlbumScreenshots
            case .livePhotos: assetSubtype = .smartAlbumLivePhotos
            case .screenRecordings: assetSubtype = .smartAlbumScreenRecordings
            }
            
            let collection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: assetSubtype, options: nil)
            var totalBytes: Int64 = 0
            
            if let firstObject = collection.firstObject {
                let result = PHAsset.fetchAssets(in: firstObject, options: nil)
                
                result.enumerateObjects { asset, _, _ in
                    var currentAssetSize: Int64 = 0
                    
                    let resources = PHAssetResource.assetResources(for: asset)
                    if let resource = resources.first,
                       let unsignedSize = resource.value(forKey: "fileSize") as? CLong {
                        currentAssetSize = Int64(unsignedSize)
                    }
                    DispatchQueue.main.async {
                        self.sizesCache[asset.localIdentifier] = currentAssetSize
                    }
                    totalBytes += currentAssetSize
                }
            }
            DispatchQueue.main.async {
                completion(totalBytes)
            }
        }
    }
    
    func getFileSize(for id: String) -> Int64 {
        return sizesCache[id] ?? 0
    }
    
    
    func deleteAssets(with ids: [String], completion: @escaping (Bool) -> Void) {
        let assetsToDelete = PHAsset.fetchAssets(withLocalIdentifiers: ids, options: nil)
        
        guard assetsToDelete.count > 0 else {
            completion(true)
            return
        }
        
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.deleteAssets(assetsToDelete)
        } completionHandler: { success, error in
            DispatchQueue.main.async {
                if success {
                    self.cacheLock.lock()
                    ids.forEach { self.assetsCache.removeValue(forKey: $0) }
                    self.cacheLock.unlock()
                }
                completion(success)
            }
        }
    }
    
    
    
    func requestImage(by id: String, targetSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        guard let asset = assetsCache[id] else {
            completion(nil)
            return
        }
        
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.isNetworkAccessAllowed = true
        
        manager.requestImage(for: asset,
                             targetSize: targetSize,
                             contentMode: .aspectFill,
                             options: options) { image, _ in
            completion(image)
        }
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
    
    func calculateGroupCount(type: GroupAlbum, completion: @escaping (Int) -> Void) {
        fetchGroupedItems(for: type) { groups in
            completion(groups.count)
        }
    }
    
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
}

extension Notification.Name {
    static let photoLibraryCountsDidUpdate = Notification.Name("photoLibraryCountsDidUpdate")
}
