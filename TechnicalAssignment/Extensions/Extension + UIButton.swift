import UIKit

extension UIButton {

    func applyPressAnimation() {
        addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        
        addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    }
    
    @objc private func animateDown(sender: UIButton) {
        animate(isPressed: true)
    }
    
    @objc private func animateUp(sender: UIButton) {
        animate(isPressed: false)
    }
    
    private func animate(isPressed: Bool) {
        let duration: TimeInterval = 0.15
        let options: UIView.AnimationOptions = [.allowUserInteraction, .curveEaseInOut]
        
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.alpha = isPressed ? 0.7 : 1.0
            self.transform = isPressed ? CGAffineTransform(scaleX: 0.99, y: 0.99) : .identity
        }, completion: nil)
    }
}
