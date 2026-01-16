import UIKit

final class CustomProgressView: UIView {
    
    private var progressLayer = CAShapeLayer()
    private var trackLayer = CAShapeLayer()
    
    let percentLabel: UILabel = {
        let label = UILabel()
        let size = CGFloat.dynamicFontSize(baseFontSize: 24)
        label.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        label.textColor = .anotherWhite
        label.textAlignment = .center
        label.text = "0%"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usedLabel: UILabel = {
        let label = UILabel()
        let size = CGFloat.dynamicFontSize(baseFontSize: 13)
        label.font = UIFont.systemFont(ofSize: size, weight: .regular)
        label.textColor = .anotherWhite
        label.textAlignment = .center
        label.text = "used"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCircularPath()
        setupLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
            radius: (min(bounds.width, bounds.height) - 20) / 2,
            startAngle: -CGFloat.pi / 2,
            endAngle: 1.5 * CGFloat.pi,
            clockwise: true
        )
        trackLayer.path = circlePath.cgPath
        progressLayer.path = circlePath.cgPath
    }
    
    private func setupCircularPath() {
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor.track.withAlphaComponent(0.5).cgColor
        trackLayer.lineWidth = 15
        trackLayer.lineCap = .round
        
        trackLayer.shadowColor = UIColor.progressMain.cgColor
        trackLayer.shadowOffset = .zero
        trackLayer.shadowRadius = 14
        trackLayer.shadowOpacity = 1.0
        layer.addSublayer(trackLayer)
        
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.progressMain.cgColor
        progressLayer.lineWidth = 15
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)
    }
    
    private func setupLabels() {
        addSubview(percentLabel)
        addSubview(usedLabel)
        
        NSLayoutConstraint.activate([
            percentLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            percentLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            
            usedLabel.topAnchor.constraint(equalTo: percentLabel.bottomAnchor, constant: 2),
            usedLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func setProgress(value: Float, text: String, animated: Bool = true) {
        let clampedValue = max(0, min(CGFloat(value), 1))
        percentLabel.text = text
        
        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.toValue = clampedValue
            animation.duration = 1.0
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            progressLayer.add(animation, forKey: "progressAnim")
        }
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        progressLayer.strokeEnd = clampedValue
        CATransaction.commit()
    }
}
