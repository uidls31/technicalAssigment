import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinatorProtocol?
    let navigation = UINavigationController()
    let storageService: StorageServiceProtocol = StorageService()
    let photoLibraryService: PhotoLibraryServiceProtocol = PhotoLibraryService()
    lazy var mediaListService: MediaListServiceProtocol = MediaListService(photoLibraryService: self.photoLibraryService)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.overrideUserInterfaceStyle = .light
        startAppCoordinator()
        return true
    }
    
    private func startAppCoordinator() {
        let factory = AppCoordinatorFactoryImp()
        appCoordinator = AppCoordinator(window: window ?? UIWindow(),
                                        navigation: navigation,
                                        factory: factory,
                                        storageService: storageService,
                                        photoLibraryService: photoLibraryService,
                                        mediaListService: mediaListService)
        appCoordinator?.start()
        navigation.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
}

