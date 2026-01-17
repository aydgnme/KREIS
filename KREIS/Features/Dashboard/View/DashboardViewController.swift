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

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.timeWheel.setProgress(0.0, animated: false)
            self.timeWheel.setProgress(0.35, animated: true)
        }
    }
    

    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .kreisBackground
        
        view.addSubview(timeWheel)
        
        NSLayoutConstraint.activate([
     
            timeWheel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeWheel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
     
            timeWheel.widthAnchor.constraint(equalToConstant: 300),
            timeWheel.heightAnchor.constraint(equalToConstant: 300)
        ])
    }

}
