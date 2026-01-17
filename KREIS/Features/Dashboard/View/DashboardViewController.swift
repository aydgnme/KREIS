//
//  DashboardViewController.swift
//  KREIS
//
//  Created by Mert Aydogan on 17.01.2026.
//

import UIKit

class DashboardViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let timeWheel: TimeWheelView = {
        let view = TimeWheelView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura-Bold", size: 52) ?? .systemFont(ofSize: 52, weight: .heavy)
        label.textColor = .kreisBlack
        label.textAlignment = .center
        label.text = "--:--"
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura-Medium", size: 16) ?? .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .kreisBlack.withAlphaComponent(0.6)
        label.textAlignment = .center
        label.text = "..."
        return label
    }()
    
    private lazy var infoStack: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [timeLabel, dateLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var addButton: CircleButton = {
        let button = CircleButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Properties
    
    private var timer: Timer?
    private var viewModel = DashboardViewModel()

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startClock()
        
        viewModel.fetchTodayTask()
        
        timeWheel.setTasks(viewModel.tasks)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        timeWheel.setTasks(viewModel.tasks)
    }
    
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .kreisBackground
        
        view.addSubview(timeWheel)
        view.addSubview(infoStack)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
     
            // Time Wheel
            timeWheel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeWheel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            timeWheel.widthAnchor.constraint(equalToConstant: 300),
            timeWheel.heightAnchor.constraint(equalToConstant: 300),
            
            // StackView
            infoStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // Add Button
            addButton.widthAnchor.constraint(equalToConstant: 56),
            addButton.heightAnchor.constraint(equalToConstant: 56),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
            
        ])
    }
    
    // MARK: - Actions
    
    @objc private func didTapAdd() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let vc = AddTaskViewController()
        vc.delegate = self
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        
        present(vc, animated: true)
    }
    
    
    // MARK: - Logic (Clock)
    
    private func startClock() {
        tick()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    
    @objc private func tick() {
        let now = Date()
        let calendar = Calendar.current
        
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeLabel.text = timeFormatter.string(from: now)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM"
        dateLabel.text = dateFormatter.string(from: now).uppercased()
        
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)
        
        let totalMinutesPassed = CGFloat(hour * 60 + minute)
        let totalMinutesInDay = 24.0 * 60.0
        
        let progress = totalMinutesPassed / totalMinutesInDay
        
        timeWheel.setProgress(progress, animated: true)
    }

}

extension DashboardViewController: AddTaskViewControllerDelegate {
    func didAddTask(_ task: Task) {
        viewModel.addNewTask(task)
        
        timeWheel.setTasks(viewModel.tasks)
        
        print("New Task added to the list.")
    }
}

// MARK: - TimeWheel Delegate
extension DashboardViewController: TimeWheelDelegate {
    func didSelectTask(_ task: Task?) {
        guard let task = task else { return }
        
        print("Task Selected: \(task.title)")
        
        
        UIView.transition(with: infoStack, duration: 0.3, options: .transitionCrossDissolve, animations: {
        
            self.timeLabel.text = task.title.uppercased()
            self.timeLabel.font = UIFont(name: "Futura-Bold", size: 32)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let start = formatter.string(from: task.startTime)
            let end = formatter.string(from: task.endTime)
            
            self.dateLabel.text = "\(start) - \(end)"
            self.dateLabel.textColor = task.type.color
        })
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(resetToClockMode), object: nil)
        perform(#selector(resetToClockMode), with: nil, afterDelay: 3.0)
    }
    
    @objc private func resetToClockMode() {
        
        tick()
        
        UIView.transition(with: infoStack, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.timeLabel.font = UIFont(name: "Futura-Bold", size: 52)
            self.timeLabel.textColor = .kreisBlack
            self.dateLabel.textColor = .kreisBlack.withAlphaComponent(0.6)
        })
    }
}
