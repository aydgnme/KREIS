//
//  CircleButton.swift
//  KREIS
//
//  Created by Mert Aydogan on 17.01.2026.
//

import UIKit

final class CircleButton: UIButton {

    // MARK: - Init
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: - Setup
        
    private func setupStyle() {
        backgroundColor = .kreisRed
        tintColor = .white
        
        layer.cornerRadius = 28
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 6
        
     
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        let image = UIImage(systemName: "plus", withConfiguration: config)
        setImage(image, for: .normal)
    }
        
    // MARK: - Touch Animations
        
    override var isHighlighted: Bool {
        didSet {
            animatePress(isHighlighted)
        }
    }
        
    private func animatePress(_ isPressed: Bool) {
        let scale: CGFloat = isPressed ? 0.90 : 1.0
        
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.layer.shadowOffset = isPressed ? CGSize(width: 0, height: 2) : CGSize(width: 0, height: 4)
            self.layer.shadowOpacity = isPressed ? 0.5 : 0.3
        }, completion: nil)
    }
}
