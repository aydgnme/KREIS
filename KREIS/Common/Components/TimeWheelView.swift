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
        
        static let totalHours = 24
        static let majorTickLength: CGFloat = 20.0
        static let minorTickLength: CGFloat = 10.0
        static let tickWidth: CGFloat = 2.0
    }
    
    private var lastFrame: CGRect = .zero
    
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
    
    private lazy var ticksLayer: CALayer = {
        let layer = CALayer()
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
        
        if bounds != lastFrame {
            drawPath()
            lastFrame = bounds
        }
    }
    
    // MARK: - Setup
    private func setupLayers() {
        layer.addSublayer(ticksLayer)
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
        
        configureTicks()
        progressLayer.path = circularPath.cgPath
        
        
    }
    
    // MARK: - Ticks Logic
    private func configureTicks() {
        ticksLayer.sublayers?.forEach {
            $0.removeFromSuperlayer()
        }
        
        let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (min(bounds.width, bounds.height) - Constants.lineWidth) / 2 - 25
        
        for i in 0..<Constants.totalHours {
            let angle = CGFloat(i) * (2.0 * CGFloat.pi / CGFloat(Constants.totalHours)) - (CGFloat.pi / 2)
            
            let isMajor = i % 6 == 0
            let length = isMajor ? Constants.majorTickLength : Constants.minorTickLength
            
            let tick = CALayer()
            tick.backgroundColor = isMajor ? UIColor.kreisBlack.cgColor : UIColor.kreisBlack.withAlphaComponent(0.5).cgColor
            
            tick.bounds = CGRect(x: 0, y: 0, width: Constants.tickWidth, height: length)
            
            let x = centerPoint.x + radius * cos(angle)
            let y = centerPoint.y + radius * sin(angle)
            tick.position = CGPoint(x: x, y: y)
            
            tick.transform = CATransform3DMakeRotation(angle + CGFloat.pi / 2, 0, 0, 1)
            
            ticksLayer.addSublayer(tick)
        }
        
    }
    
    // MARK: - Public Methods
    func setProgress(_ value: CGFloat, animated: Bool = true) {
        let clampedValue = max(0, min(1, value))
        
        let oldValue = progressLayer.strokeEnd
        
        progressLayer.strokeEnd = clampedValue
        
        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = oldValue
            animation.toValue = clampedValue
            animation.duration = 1.0
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            
            progressLayer.add(animation, forKey: "progressAnim")
        }
    }
}

