import UIKit

protocol MediaListFactoryProtocol {
    func createMediaListViewController(outputBack: (any MediaListViewControllerOutputBack)?,
                                       mediaListService: MediaListServiceProtocol,
                                       output: (any MediaListViewControllerOutput)?,
                                       outputToGroupAlbum: (any MediaListViewControllerOutputToGroupAlbum)?) -> UIViewController
    func createSmartAlbumViewController(outputBack: (any SmarAlbumViewControllerProtocolOutputBack)?,
                                        albumType: SmartAlbumType,
                                        photoService: any PhotoLibraryServiceProtocol) -> UIViewController
    func createGroupAlbumViewController(outputBackGroup: (any GroupAlbumViewControllerOutputBack)?,
                                        groupAlbumType: GroupAlbum,
                                        photoService: any PhotoLibraryServiceProtocol) -> UIViewController
}

struct MediaListFactoryImp: MediaListFactoryProtocol{
    
    func createMediaListViewController(outputBack: (any MediaListViewControllerOutputBack)?,
                                       mediaListService: MediaListServiceProtocol,
                                       output: (any MediaListViewControllerOutput)?,
                                       outputToGroupAlbum: (any MediaListViewControllerOutputToGroupAlbum)?) -> UIViewController {
        let viewModelMediaList: MediaListViewModelProtocol = MediaListViewModel(mediaListService: mediaListService)
        let customView: MediaListViewProtocol = MediaListView()
        let viewController = MediaListViewController(customViewMediaList: customView,
                                                     outputBack: outputBack,
                                                     viewModelMediaList: viewModelMediaList,
                                                     output: output,
                                                     outputToGroupAlbum: outputToGroupAlbum)
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
    
    func createGroupAlbumViewController(outputBackGroup: (any GroupAlbumViewControllerOutputBack)?,
                                        groupAlbumType: GroupAlbum,
                                        photoService: any PhotoLibraryServiceProtocol) -> UIViewController {
        let customGroupAlbumView: GroupAlbumViewProtocol = GroupAlbumView()
        let viewModelGroupAlbum: GroupAlbumViewModelProtocol = GroupAlbumViewModel(groupAlbumType: groupAlbumType,
                                                                                   photoService: photoService)
        let viewController = GroupAlbumViewController(customGroupAlbumView: customGroupAlbumView,
                                                      outputBackGroup: outputBackGroup,
                                                      viewModelGroupAlbum: viewModelGroupAlbum)
        
        return viewController
    }
}
