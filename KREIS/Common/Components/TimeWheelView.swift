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
        
        static let indicatiorSize: CGFloat = 32.0
        static let indicatorColor: UIColor = .kreisBlack
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
    
    private lazy var tasksLayer: CALayer = {
        let layer = CALayer()
        return layer
    }()
    
    private lazy var indicatorLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = Constants.indicatorColor.cgColor
        layer.bounds = CGRect(x: 0, y: 0, width: 4, height: Constants.indicatiorSize)
        layer.cornerRadius = 2
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 3
        
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
        layer.addSublayer(trackLayer)
        layer.addSublayer(tasksLayer)
        layer.addSublayer(ticksLayer)
        layer.addSublayer(progressLayer)
        layer.addSublayer(indicatorLayer)
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
            
            let angle = (clampedValue * 2 * CGFloat.pi)
            
            
            indicatorLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
            
            let radius = (min(bounds.width, bounds.height) - Constants.lineWidth) / 2
            
            let targetAngle = angle - (CGFloat.pi / 2)
            
            let x = bounds.midX + radius * cos(targetAngle)
            let y = bounds.midY + radius * sin(targetAngle)
            
            if animated {
                let animation = CABasicAnimation(keyPath: "position")
                animation.fromValue = indicatorLayer.position
                animation.toValue = CGPoint(x: x, y: y)
                animation.duration = 1.0
                animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
                indicatorLayer.position = CGPoint(x: x, y: y)
                indicatorLayer.add(animation, forKey: "moveIndicator")
                
                let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
                rotationAnim.toValue = targetAngle + (CGFloat.pi / 2) // İbre çembere dik dursun
                rotationAnim.duration = 1.0
                rotationAnim.fillMode = .forwards
                rotationAnim.isRemovedOnCompletion = false
                indicatorLayer.add(rotationAnim, forKey: "rotateIndicator")
                
                indicatorLayer.transform = CATransform3DMakeRotation(targetAngle + (CGFloat.pi / 2), 0, 0, 1)
                
            } else {
                indicatorLayer.position = CGPoint(x: x, y: y)
                indicatorLayer.transform = CATransform3DMakeRotation(targetAngle + (CGFloat.pi / 2), 0, 0, 1)
            }
        }
    
    // MARK: - Task Drawing Logic
    func setTasks(_ tasks: [Task]) {
        tasksLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (min(bounds.width, bounds.height) - Constants.lineWidth) / 2
        
        for task in tasks {
            
            let startAngle = dateToAngle(date: task.startTime)
            let endAngle = dateToAngle(date: task.endTime)
            
            
            let path = UIBezierPath(
                arcCenter: centerPoint,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: true
            )
            
            
            let shape = CAShapeLayer()
            shape.path = path.cgPath
            shape.strokeColor = task.type.color.cgColor
            shape.fillColor = UIColor.clear.cgColor
            
            shape.lineWidth = Constants.lineWidth
            shape.lineCap = .butt
            
            
            tasksLayer.addSublayer(shape)
        }
    }
        
        
    private func dateToAngle(date: Date) -> CGFloat {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        
        let totalMinutes = CGFloat(hour * 60 + minute)
        let totalMinutesInDay: CGFloat = 1440.0 // 24 * 60
        
        
        let ratio = totalMinutes / totalMinutesInDay
        
        
        return (ratio * 2 * CGFloat.pi) - (CGFloat.pi / 2)
    }
}

