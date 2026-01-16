import Photos
import UIKit

protocol PhotoLibraryServiceProtocol: AnyObject {
    func requestAccess(completion: @escaping (Bool) -> Void)
    func calculateBreakdown(completion: @escaping (PhotoLibraryService.LibraryBreakdown) -> Void)
}

class PhotoLibraryService: PhotoLibraryServiceProtocol {
    
    // Структура для хранения данных одной категории
    struct CategoryStats {
        let count: Int
        let sizeBytes: Int64
        
        // Вспомогательное свойство для красивой строки "54.7 GB"
        var formattedSize: String {
            return ByteCountFormatter.string(fromByteCount: sizeBytes, countStyle: .file)
        }
    }
    
    // Структура, которая хранит ВСЮ статистику сразу
    struct LibraryBreakdown {
        let videoStats: CategoryStats
        let photoStats: CategoryStats
    }
    
    func requestAccess(completion: @escaping (Bool) -> Void) {
            // .readWrite — это полный доступ (для iOS 14+)
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                DispatchQueue.main.async {
                    // Возвращаем true, если юзер нажал "Allow Full Access" или "Limit Access"
                    completion(status == .authorized || status == .limited)
                }
            }
        }
    
    func calculateBreakdown(completion: @escaping (LibraryBreakdown) -> Void) {
        
        // 1. Проверяем права
        guard PHPhotoLibrary.authorizationStatus(for: .readWrite) == .authorized else {
            let empty = CategoryStats(count: 0, sizeBytes: 0)
            completion(LibraryBreakdown(videoStats: empty, photoStats: empty))
            return
        }
        
        // 2. Считаем в фоне
        DispatchQueue.global(qos: .userInitiated).async {
            let fetchOptions = PHFetchOptions()
            // Берем всё сразу, чтобы пройтись по циклу один раз
            let allAssets = PHAsset.fetchAssets(with: fetchOptions)
            
            var videoCount = 0
            var videoSize: Int64 = 0
            
            var photoCount = 0
            var photoSize: Int64 = 0
            
            // 3. Единый цикл (Самый быстрый способ)
            allAssets.enumerateObjects { asset, _, _ in
                
                // Получаем размер файла
                var assetSize: Int64 = 0
                let resources = PHAssetResource.assetResources(for: asset)
                if let resource = resources.first,
                   let unsignedSize = resource.value(forKey: "fileSize") as? CLong {
                    assetSize = Int64(unsignedSize)
                }
                
                // Сортируем: Видео налево, Фото направо
                if asset.mediaType == .video {
                    videoCount += 1
                    videoSize += assetSize
                } else if asset.mediaType == .image {
                    photoCount += 1
                    photoSize += assetSize
                }
            }
            
            // 4. Формируем результат
            let result = LibraryBreakdown(
                videoStats: CategoryStats(count: videoCount, sizeBytes: videoSize),
                photoStats: CategoryStats(count: photoCount, sizeBytes: photoSize)
            )
            
            // 5. Возвращаем на UI
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
