import UIKit

extension UIScreen {
    var isSmallScreen: Bool {
        return UIScreen.main.bounds.height <= 667
    }
}

extension UIScreen {
    var isBigScreen: Bool {
        return UIScreen.main.bounds.height >= 667
    }
    
    var isProMax: Bool {
        return UIScreen.main.bounds.height == 956
    }
}
