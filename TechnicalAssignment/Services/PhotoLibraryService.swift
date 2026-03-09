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
    private let serviceQueue = DispatchQueue(label: "com.app.PhotoLibraryService", qos: .userInitiated)
    private var assetsCache: [String: PHAsset] = [:]
    private var sizesCache: [String: Int64] = [:]
    private var cachedGroupCounts: [GroupAlbum: Int] = [:]
    private var isCalculating: [GroupAlbum: Bool] = [:]
    
    private func fileSize(for asset: PHAsset) -> Int64 {
            guard let resource = PHAssetResource.assetResources(for: asset).first,
                  let size = resource.value(forKey: "fileSize") as? CLong else { return 0 }
            return Int64(size)
        }
    
    private func cacheAsset(_ asset: PHAsset) {
        assetsCache[asset.localIdentifier] = asset
    }
    
    func requestAccess(completion: @escaping (Bool) -> Void) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                DispatchQueue.main.async {
                    completion(status == .authorized || status == .limited)
                }
            }
        }
    
    func requestAccessWithSmartDelay(completion: @escaping (Bool) -> Void) {
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            let delay: TimeInterval = status == .notDetermined ? 1.5 : 0
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.requestAccess(completion: completion)
            }
        }
    
    func getSmartAlbumCount(type: SmartAlbumType) -> Int {
            guard let collection = type.fetchCollection() else { return 0 }
            return PHAsset.fetchAssets(in: collection, options: nil).count
        }

        func fetchItems(for type: SmartAlbumType) -> [SmartAlbumModel] {
            guard let collection = type.fetchCollection() else { return [] }

            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

            var items: [SmartAlbumModel] = []
            PHAsset.fetchAssets(in: collection, options: options)
                .enumerateObjects { [weak self] asset, _, _ in
                    self?.cacheAsset(asset)
                    items.append(SmartAlbumModel(id: asset.localIdentifier, size: 0, isSelected: false))
                }
            return items
        }
    
    func calculateTotalSize(for type: SmartAlbumType, completion: @escaping (Int64) -> Void) {
            serviceQueue.async { [weak self] in
                guard let self, let collection = type.fetchCollection() else {
                    DispatchQueue.main.async { completion(0) }
                    return
                }

                var total: Int64 = 0
                PHAsset.fetchAssets(in: collection, options: nil)
                    .enumerateObjects { asset, _, _ in
                        let size = self.fileSize(for: asset)
                        self.sizesCache[asset.localIdentifier] = size
                        total += size
                    }

                DispatchQueue.main.async { completion(total) }
            }
        }

        func getFileSize(for id: String) -> Int64 {
            sizesCache[id] ?? 0
        }
    
    func getGroupAlbumCount(type: GroupAlbum) -> Int {
            if let cached = cachedGroupCounts[type] { return cached }
            guard isCalculating[type] != true else { return 0 }

            isCalculating[type] = true
            fetchGroupedItems(for: type) { [weak self] groups in
                self?.cachedGroupCounts[type] = groups.count
                self?.isCalculating[type] = false
                NotificationCenter.default.post(name: .photoLibraryCountsDidUpdate, object: nil)
            }
            return 0
        }
    
    func fetchGroupedItems(for type: GroupAlbum, completion: @escaping ([[GroupAlbumModel]]) -> Void) {
            serviceQueue.async { [weak self] in
                guard let self else { return }

                let options = PHFetchOptions()
                options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

                let mediaType: PHAssetMediaType = (type == .similarVideos) ? .video : .image
                let allAssets = PHAsset.fetchAssets(with: mediaType, options: options)

                let groups: [[PHAsset]]
                switch type {
                case .duplicatePhotos:
                    groups = self.findDuplicates(in: allAssets)
                default:
                    groups = self.findSimilar(in: allAssets, threshold: 1.5)
                }

                let result = groups.flatMap { self.chunkIntoPairs(assets: $0) }
                DispatchQueue.main.async { completion(result) }
            }
        }
    
    func calculateGroupTotalSize(for type: GroupAlbum, completion: @escaping (Int64) -> Void) {
        serviceQueue.async { [weak self] in
            guard let self else { return }

            let total = self.assetsCache.values.reduce(Int64(0)) { $0 + self.fileSize(for: $1) }
            DispatchQueue.main.async { completion(total) }
        }
    }
    
    func requestImage(by id: String, targetSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        guard let asset = assetsCache[id] else { return completion(nil) }

        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.isNetworkAccessAllowed = true

        PHImageManager.default().requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: .aspectFill,
            options: options
        ) { image, _ in completion(image) }
    }
    
    func deleteAssets(with ids: [String], completion: @escaping (Bool) -> Void) {
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: ids, options: nil)
        guard assets.count > 0 else { return completion(true) }

        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.deleteAssets(assets)
        } completionHandler: { [weak self] success, _ in
            DispatchQueue.main.async {
                if success { ids.forEach { self?.assetsCache.removeValue(forKey: $0) } }
                completion(success)
            }
        }
    }
    
    func calculateBreakdown(completion: @escaping (LibraryBreakdown) -> Void) {
        guard PHPhotoLibrary.authorizationStatus(for: .readWrite) == .authorized else {
            return completion(LibraryBreakdown(videoStats: .empty, photoStats: .empty))
        }

        serviceQueue.async { [weak self] in
            guard let self else { return }

            var videoCount = 0, videoSize: Int64 = 0
            var photoCount = 0, photoSize: Int64 = 0

            PHAsset.fetchAssets(with: PHFetchOptions())
                .enumerateObjects { asset, _, _ in
                    let size = self.fileSize(for: asset)
                    switch asset.mediaType {
                    case .video: videoCount += 1; videoSize += size
                    case .image: photoCount += 1; photoSize += size
                    default: break
                    }
                }

            let result = LibraryBreakdown(
                videoStats: CategoryStats(count: videoCount, sizeBytes: videoSize),
                photoStats: CategoryStats(count: photoCount, sizeBytes: photoSize)
            )
            DispatchQueue.main.async { completion(result) }
        }
    }
    
    private func findDuplicates(in assets: PHFetchResult<PHAsset>) -> [[PHAsset]] {
        var grouped = [String: [PHAsset]]()
        assets.enumerateObjects { asset, _, _ in
            guard let date = asset.creationDate else { return }
            let key = "\(Int(date.timeIntervalSince1970))_\(asset.pixelWidth)_\(asset.pixelHeight)"
            grouped[key, default: []].append(asset)
        }
        return grouped.values.filter { $0.count > 1 }
    }
    
    private func findSimilar(in assets: PHFetchResult<PHAsset>, threshold: TimeInterval) -> [[PHAsset]] {
        var result: [[PHAsset]] = []
        var current: [PHAsset] = []

        assets.enumerateObjects { asset, _, _ in
            guard let date = asset.creationDate else { return }

            if let last = current.last?.creationDate,
               abs(date.timeIntervalSince(last)) < threshold {
                current.append(asset)
            } else {
                if current.count >= 2 { result.append(current) }
                current = [asset]
            }
        }
        if current.count >= 2 { result.append(current) }
        return result
    }
    
    private func chunkIntoPairs(assets: [PHAsset]) -> [[GroupAlbumModel]] {
        stride(from: 0, to: assets.count - 1, by: 2).map { i in
            let a = assets[i], b = assets[i + 1]
            cacheAsset(a)
            cacheAsset(b)
            return [
                GroupAlbumModel(id: a.localIdentifier, size: 0, isSelected: false),
                GroupAlbumModel(id: b.localIdentifier, size: 0, isSelected: true)
            ]
        }
    }
}

extension SmartAlbumType {
    var phSubtype: PHAssetCollectionSubtype {
        switch self {
        case .screenshots:      return .smartAlbumScreenshots
        case .livePhotos:       return .smartAlbumLivePhotos
        case .screenRecordings: return .smartAlbumScreenRecordings
        }
    }

    func fetchCollection() -> PHAssetCollection? {
        PHAssetCollection
            .fetchAssetCollections(with: .smartAlbum, subtype: phSubtype, options: nil)
            .firstObject
    }
}

extension PhotoLibraryService {
    struct CategoryStats {
        let count: Int
        let sizeBytes: Int64

        static let empty = CategoryStats(count: 0, sizeBytes: 0)

        var formattedSize: String {
            ByteCountFormatter.string(fromByteCount: sizeBytes, countStyle: .file)
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
