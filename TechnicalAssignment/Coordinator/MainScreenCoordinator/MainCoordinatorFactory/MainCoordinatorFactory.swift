import UIKit

protocol MainCoordinatorFactoryProtocol {
    func createMainScreenViewController() -> UIViewController
}

struct MainCoordinatorFactoryImp: MainCoordinatorFactoryProtocol {
    func createMainScreenViewController() -> UIViewController {
        let viewController = MainScreenViewController()
        return viewController
    }
}
