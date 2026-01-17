//
//  TriangleButton.swift
//  KREIS
//
//  Created by Mert Aydogan on 17.01.2026.
//

import UIKit

final class TriangleButton: UIButton {

    enum Direction {
        case up
        case down
    }
    
    private let direction: Direction
    private let color: UIColor
    
    // MARK: - Init
    
    init(direction: Direction, color: UIColor = .kreisBlack) {
        self.direction = direction
        self.color = color
        super.init(frame: .zero)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        
    // MARK: - Draw (Core Graphics)
        
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.beginPath()
        context.setFillColor(color.cgColor)
        
    
        let w = rect.width
        let h = rect.height
        
        if direction == .up {
            context.move(to: CGPoint(x: w / 2, y: 4))
            context.addLine(to: CGPoint(x: w - 4, y: h - 4))
            context.addLine(to: CGPoint(x: 4, y: h - 4))
        } else {
            context.move(to: CGPoint(x: 4, y: 4))
            context.addLine(to: CGPoint(x: w - 4, y: 4))
            context.addLine(to: CGPoint(x: w / 2, y: h - 4))
        }
        
        context.closePath()
        context.fillPath()
    }
        
     
    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.5 : 1.0
        }
    }
    
}
