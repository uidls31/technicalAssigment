import Foundation

struct StorageInfo {
    let totalSpace: String
    let usedSpace: String
    let usedPercentage: Float
}

protocol StorageServiceProtocol: AnyObject {
    func getStorageInfo() -> StorageInfo?
}

class StorageService: StorageServiceProtocol {
    
    func getStorageInfo() -> StorageInfo? {
        guard let dictionary = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()) else {
            return nil
        }
        
        let totalSpaceInBytes = dictionary[.systemSize] as? Int64 ?? 0
        let freeSpaceInBytes = dictionary[.systemFreeSize] as? Int64 ?? 0
        let usedSpaceInBytes = totalSpaceInBytes - freeSpaceInBytes
        
        let percentage = totalSpaceInBytes > 0 ? Float(usedSpaceInBytes) / Float(totalSpaceInBytes) : 0.0
        
        return StorageInfo(totalSpace: ByteCountFormatter.string(fromByteCount: totalSpaceInBytes,
                                                                 countStyle: .file),
                           usedSpace: ByteCountFormatter.string(fromByteCount: usedSpaceInBytes,
                                                                countStyle: .file),
                           usedPercentage: percentage)
    }
}
