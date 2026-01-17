//
//  TimeWheelView.swift
//  KREIS
//
//  Created by Mert Aydogan on 17.01.2026.
//

import UIKit

final class TimeWheelView: UIView {
    
    // MARK: - Constants
    private enum Constants {
        static let lineWidth: CGFloat = 24.0
        static let startAngle: CGFloat = -CGFloat.pi / 2
        static let endAngle: CGFloat = 1.5 * CGFloat.pi
    }
    
    // MARK: - UI Components
    private lazy var trackLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.kreisBlack.withAlphaComponent(0.1).cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = Constants.lineWidth
        layer.lineCap = .butt
        return layer
    }()
    
    private lazy var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.kreisBlue.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = Constants.lineWidth
        layer.lineCap = .butt
        layer.strokeEnd = 0.0
        return layer
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        drawPath()
    }
    
    // MARK: - Setup
    private func setupLayers() {
        layer.addSublayer(trackLayer)
        layer.addSublayer(progressLayer)
    }
    
    private func drawPath() {
        let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (min(bounds.width, bounds.height) - Constants.lineWidth) / 2
        
        let circularPath = UIBezierPath(
            arcCenter: centerPoint,
            radius: radius,
            startAngle: Constants.startAngle,
            endAngle: Constants.endAngle,
            clockwise: true
        )
        
        trackLayer.path = circularPath.cgPath
        progressLayer.path = circularPath.cgPath
    }
    
    // MARK: - Public Methods
    func setProgress(_ value: CGFloat, animated: Bool = true) {
        let clampedValue = max(0, min(1, value))
        
        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = progressLayer.strokeEnd
            animation.toValue = clampedValue
            animation.duration = 1.0
            animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.19, 1.0, 0.22, 1.0)
            
            progressLayer.strokeEnd = clampedValue
            progressLayer.add(animation, forKey: "animateProgress")
        } else {
            progressLayer.strokeEnd = clampedValue
        }
    }
}

