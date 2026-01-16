import UIKit

protocol MediaListFactoryProtocol {
    func createMediaListViewController(outputBack: (any MediaListViewControllerOutputBack)?) -> UIViewController
}

struct MediaListFactoryImp: MediaListFactoryProtocol{
    
    func createMediaListViewController(outputBack: (any MediaListViewControllerOutputBack)?) -> UIViewController {
        let customView: MediaListViewProtocol = MediaListView()
        let viewController = MediaListViewController(customViewMediaList: customView,
                                                     outputBack: outputBack)
        return viewController
    }
}
