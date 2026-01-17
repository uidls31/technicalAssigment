import UIKit

protocol MediaListFactoryProtocol {
    func createMediaListViewController(outputBack: (any MediaListViewControllerOutputBack)?,
                                       mediaListService: MediaListServiceProtocol,
                                       output: (any MediaListViewControllerOutput)?) -> UIViewController
    func createSmartAlbumViewController(outputBack: (any SmarAlbumViewControllerProtocolOutputBack)?,
                                        albumType: SmartAlbumType,
                                        photoService: any PhotoLibraryServiceProtocol) -> UIViewController
}

struct MediaListFactoryImp: MediaListFactoryProtocol{
    
    func createMediaListViewController(outputBack: (any MediaListViewControllerOutputBack)?,
                                       mediaListService: MediaListServiceProtocol,
                                       output: (any MediaListViewControllerOutput)?) -> UIViewController {
        let viewModelMediaList: MediaListViewModelProtocol = MediaListViewModel(mediaListService: mediaListService)
        let customView: MediaListViewProtocol = MediaListView()
        let viewController = MediaListViewController(customViewMediaList: customView,
                                                     outputBack: outputBack,
                                                     viewModelMediaList: viewModelMediaList,
                                                     output: output)
        return viewController
    }
    
    func createSmartAlbumViewController(outputBack: (any SmarAlbumViewControllerProtocolOutputBack)?,
                                        albumType: SmartAlbumType,
                                        photoService: any PhotoLibraryServiceProtocol) -> UIViewController {
        let viewModelSmartAlbum: SmartAlbumViewModelProtocol = SmartAlbumViewModel(albumType: albumType,
                                                                                   photoService: photoService)
        let customView: SmarAlbumViewProtocol = SmarAlbumView()
        let viewController = SmarAlbumViewController(customViewSmartAlbum: customView,
                                                     outputBack: outputBack,
                                                     viewModelSmartAlbum: viewModelSmartAlbum)
        return viewController
    }
}
