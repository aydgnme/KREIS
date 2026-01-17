//
//  DashboardViewModel.swift
//  KREIS
//
//  Created by Mert Aydogan on 17.01.2026.
//

import Foundation

final class DashboardViewModel {
    
    // MARK: - Properties
    
    private(set) var tasks: [Task] = []
    
    // MARK: - Public Methods
    
    func fetchTodayTask() {
        let calendar = Calendar.current
        let now = Date()
        
        func date(hour: Int, minute: Int) -> Date {
            return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: now) ?? now
        }
        
        self.tasks = [
            
        ]
    }
    
    func addNewTask(_ task: Task) {
        tasks.append(task)
        tasks.sort { $0.startTime < $1.startTime }
    }
}
