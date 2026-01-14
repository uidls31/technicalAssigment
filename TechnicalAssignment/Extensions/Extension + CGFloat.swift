import UIKit

extension CGFloat {
    static func dynamicFontSize(baseFontSize: CGFloat, baseScreenHeight: CGFloat = 844) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        let scalingFactor = screenHeight / baseScreenHeight
        return baseFontSize * scalingFactor
    }
}
