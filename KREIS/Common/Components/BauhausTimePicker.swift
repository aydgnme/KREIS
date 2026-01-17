//
//  BauhausTimePicker.swift
//  KREIS
//
//  Created by Mert Aydogan on 17.01.2026.
//

import UIKit

final class BauhausTimePicker: UIView {
    
    var onDateChanged: ((Date) -> Void)?
    
    private(set) var date: Date = Date()
    
    // MARK: - UI Components
    
    // Hour
    private lazy var hourUpBtn = createButton(dir: .up, action: #selector(hourUp))
    private lazy var hourDownBtn = createButton(dir: .down, action: #selector(hourDown))
    private lazy var hourLabel = createLabel()
    
    // Minutes
    private lazy var minuteUpBtn = createButton(dir: .up, action: #selector(minuteUp))
    private lazy var minuteDownBtn = createButton(dir: .down, action: #selector(minuteDown))
    private lazy var minuteLabel = createLabel()

    // (:)
    private lazy var separatorLabel: UILabel = {
        let lbl = createLabel()
        lbl.text = ":"
        return lbl
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        updateLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
            
    // MARK: - Setup
            
    private func setupLayout() {
        let hourStack = UIStackView(arrangedSubviews: [hourUpBtn, hourLabel, hourDownBtn])
        hourStack.axis = .vertical
        hourStack.alignment = .center
        hourStack.spacing = 4
        
        let minuteStack = UIStackView(arrangedSubviews: [minuteUpBtn, minuteLabel, minuteDownBtn])
        minuteStack.axis = .vertical
        minuteStack.alignment = .center
        minuteStack.spacing = 4
        
        let mainStack = UIStackView(arrangedSubviews: [hourStack, separatorLabel, minuteStack])
        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.spacing = 12
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainStack)
        
        // Constraints
        NSLayoutConstraint.activate([
            mainStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            hourUpBtn.widthAnchor.constraint(equalToConstant: 40),
            hourUpBtn.heightAnchor.constraint(equalToConstant: 30),
            hourDownBtn.widthAnchor.constraint(equalToConstant: 40),
            hourDownBtn.heightAnchor.constraint(equalToConstant: 30),
            
            minuteUpBtn.widthAnchor.constraint(equalToConstant: 40),
            minuteUpBtn.heightAnchor.constraint(equalToConstant: 30),
            minuteDownBtn.widthAnchor.constraint(equalToConstant: 40),
            minuteDownBtn.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
            
    // MARK: - Helpers
            
    private func createButton(dir: TriangleButton.Direction, action: Selector) -> TriangleButton {
        let btn = TriangleButton(direction: dir)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: action, for: .touchUpInside)
        return btn
    }
            
    private func createLabel() -> UILabel {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Futura-Bold", size: 36)
        lbl.textColor = .kreisBlack
        lbl.textAlignment = .center
        return lbl
    }
            
    private func updateLabels() {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        hourLabel.text = String(format: "%02d", hour)
        minuteLabel.text = String(format: "%02d", minute)
        
        onDateChanged?(date)
    }
            
    private func addTime(component: Calendar.Component, value: Int) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        let calendar = Calendar.current
        if let newDate = calendar.date(byAdding: component, value: value, to: date) {
            self.date = newDate
            updateLabels()
        }
    }
            
    // MARK: - Actions
            
    @objc private func hourUp() { addTime(component: .hour, value: 1) }
    @objc private func hourDown() { addTime(component: .hour, value: -1) }
            
    @objc private func minuteUp() { addTime(component: .minute, value: 15) }
    @objc private func minuteDown() { addTime(component: .minute, value: -15) }
            
    
    // MARK: - Public
            
    func setDate(_ date: Date) {
        self.date = date
        updateLabels()
    }
}
