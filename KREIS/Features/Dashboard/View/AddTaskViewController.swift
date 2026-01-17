//
//  AddTaskViewController.swift
//  KREIS
//
//  Created by Mert Aydogan on 17.01.2026.
//

import UIKit

protocol AddTaskViewControllerDelegate: AnyObject {
    func didAddTask(_ task: Task)
}

class AddTaskViewController: UIViewController {
    
    // MARK: - Delegate
    weak var delegate: AddTaskViewControllerDelegate?
    
    // Custom Picker
    private let startPicker = BauhausTimePicker()
    private let endPicker = BauhausTimePicker()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCategoryButtons()
        
        startPicker.setDate(Date())
        endPicker.setDate(Date().addingTimeInterval(3600))
        
        setupKeyboardDismiss()
    }
    
    
    // MARK: - UI Components
    
    /// Label
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "NEW TASK"
        label.font = UIFont(name: "Futura-Bold", size: 24)
        label.textColor = .kreisBlack
        return label
    }()
    
    private let titleTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Wyd?"
        tf.font = UIFont(name: "Futura-Medium", size: 20)
        tf.borderStyle = .none
        tf.textColor = .kreisBlack
        return tf
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .kreisBlack
        return view
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "CATEGORY"
        label.font = UIFont(name: "Futura-Bold", size: 14)
        label.textColor = .kreisBlack.withAlphaComponent(0.5)
        return label
    }()
    
    private lazy var categoryStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 16
        return stack
    }()
    
    // SaveBtn
    private lazy var saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("CREATE BLOCK", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Futura-Bold", size: 18)
        btn.backgroundColor = .kreisBlack
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 12
        btn.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        return btn
    }()
    
    
    //MARK: - Properties
    
    private var selectedType: TaskType = .work
    private var typeButtons: [UIButton] = []
    
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .kreisBackground
        
        // Add elements
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(separatorLine)
        view.addSubview(categoryLabel)
        view.addSubview(categoryStack)
        
        let timeLabel = UILabel()
        timeLabel.text = "TIME BLOCK"
        timeLabel.font = UIFont(name: "Futura-Bold", size: 14)
        timeLabel.textColor = .kreisBlack.withAlphaComponent(0.5)
        
        view.addSubview(timeLabel)
        view.addSubview(startPicker)
        view.addSubview(endPicker)
        view.addSubview(saveButton)
        
        startPicker.translatesAutoresizingMaskIntoConstraints = false
        endPicker.translatesAutoresizingMaskIntoConstraints = false
        
        // Autolayout (Constraints)
        [titleLabel, titleTextField, separatorLine, categoryLabel, categoryStack, timeLabel, startPicker, endPicker, saveButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // Title
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            // TextField
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            // Seperator Line
            separatorLine.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            separatorLine.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 2),
            
            // Category
            categoryLabel.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 40),
            categoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            categoryStack.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 16),
            categoryStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            categoryStack.heightAnchor.constraint(equalToConstant: 44),
            
            // Time
            timeLabel.topAnchor.constraint(equalTo: categoryStack.bottomAnchor, constant: 40),
            timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            // Start Picker
            startPicker.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 16),
            startPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -80),
            startPicker.widthAnchor.constraint(equalToConstant: 100),
            startPicker.heightAnchor.constraint(equalToConstant: 120),
            
            // End Picker
            endPicker.centerYAnchor.constraint(equalTo: startPicker.centerYAnchor),
            endPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 80),
            endPicker.widthAnchor.constraint(equalToConstant: 100),
            endPicker.heightAnchor.constraint(equalToConstant: 120),
            
            // Save
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            saveButton.heightAnchor.constraint(equalToConstant: 56)
            
        ])
        
        let arrowLabel = UILabel()
        arrowLabel.text = "→"
        arrowLabel.font = UIFont(name: "Futura-Bold", size: 24)
        arrowLabel.textColor = .kreisBlack
        arrowLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(arrowLabel)
        
        NSLayoutConstraint.activate([
            arrowLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            arrowLabel.centerYAnchor.constraint(equalTo: startPicker.centerYAnchor)
        ])
    }
    
    private func setupKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        titleTextField.delegate = self
        titleTextField.returnKeyType = .done
    }
    
    private func setupCategoryButtons() {
        let types: [TaskType] = [.work, .personal, .routine, .sleep]
        
        for (index, type) in types.enumerated() {
            let btn = UIButton()
            btn.backgroundColor = type.color
            btn.layer.cornerRadius = 22 // 44/2
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.widthAnchor.constraint(equalToConstant: 44).isActive = true
            btn.heightAnchor.constraint(equalToConstant: 44).isActive = true
            
            btn.tag = index
            btn.addTarget(self, action: #selector(didSelectType(_:)), for: .touchUpInside)
            
            
            if index == 0 {
                btn.layer.borderWidth = 3
                btn.layer.borderColor = UIColor.kreisBlack.cgColor
                btn.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }
            
            categoryStack.addArrangedSubview(btn)
            typeButtons.append(btn)
        }
    }
    
    
    // MARK: - Actions
    
    @objc private func didSelectType(_ sender: UIButton) {
        // Haptic
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        
        typeButtons.forEach { btn in
            UIView.animate(withDuration: 0.2) {
                if btn == sender {
                    btn.layer.borderWidth = 3
                    btn.layer.borderColor = UIColor.kreisBlack.cgColor
                    btn.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    
                    let types: [TaskType] = [.work, .personal, .routine, .sleep]
                    self.selectedType = types[btn.tag]
                    
                } else {
                    btn.layer.borderWidth = 0
                    btn.transform = .identity
                }
            }
        }
    }
    
    @objc private func didTapSave() {
        guard let title = titleTextField.text, !title.isEmpty else {
            return
        }
        
        let newTask = Task(title: title, type: selectedType, startTime: startPicker.date, endTime: endPicker.date)
        
        delegate?.didAddTask(newTask)
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        dismiss(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension AddTaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
