import UIKit

protocol MediaListViewControllerOutputBack: AnyObject {
    func back()
}

class MediaListViewController: UIViewController {
    
    let customViewMediaList: MediaListViewProtocol
    weak var outputBack: MediaListViewControllerOutputBack?
    
    init(customViewMediaList: MediaListViewProtocol,
         outputBack: MediaListViewControllerOutputBack?) {
        self.customViewMediaList = customViewMediaList
        self.outputBack = outputBack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = customViewMediaList as? UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        
    }
    
    private func setupActions() {
        customViewMediaList.navigationBarMediaList.setBackButtonAction {
            self.outputBack?.back()
        }
    }
}
