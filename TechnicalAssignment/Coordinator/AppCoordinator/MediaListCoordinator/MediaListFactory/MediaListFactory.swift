import UIKit

protocol MediaListFactoryProtocol {
    func createMediaListViewController(outputBack: (any MediaListViewControllerOutputBack)?,
                                       mediaListService: MediaListServiceProtocol) -> UIViewController
}

struct MediaListFactoryImp: MediaListFactoryProtocol{
    
    func createMediaListViewController(outputBack: (any MediaListViewControllerOutputBack)?,
                                       mediaListService: MediaListServiceProtocol) -> UIViewController {
        let viewModelMediaList: MediaListViewModelProtocol = MediaListViewModel(mediaListService: mediaListService)
        let customView: MediaListViewProtocol = MediaListView()
        let viewController = MediaListViewController(customViewMediaList: customView,
                                                     outputBack: outputBack,
                                                     viewModelMediaList: viewModelMediaList)
        return viewController
    }
}
