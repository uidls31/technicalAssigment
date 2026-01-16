import UIKit

protocol MainCoordinatorFactoryProtocol {
    func createMainScreenViewController(storageService: any StorageServiceProtocol,
                                        photoLibraryService: any PhotoLibraryServiceProtocol,
                                        outputToMediaList: (any MainScreenViewControllerProtocol)?) -> UIViewController
}

struct MainCoordinatorFactoryImp: MainCoordinatorFactoryProtocol {
    func createMainScreenViewController(storageService: any StorageServiceProtocol,
                                        photoLibraryService: any PhotoLibraryServiceProtocol,
                                        outputToMediaList: (any MainScreenViewControllerProtocol)?) -> UIViewController {
        let view = MainScreenView()
        let viewModel = MainScreenViewModel(storageService: storageService,
                                            photoLibraryService: photoLibraryService)
        let viewController = MainScreenViewController(customViewMainScreen: view,
                                                      viewModelMainScreen: viewModel,
                                                      outputToMediaList: outputToMediaList)
        return viewController
    }
}
