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
            Task(title: "Morning Routine", type: .routine, startTime: date(hour: 7, minute: 0), endTime: date(hour: 8, minute: 30)),
            Task(title: "Deep Work", type: .work, startTime: date(hour: 9, minute: 0), endTime: date(hour: 12, minute: 30)),
            Task(title: "Lunch & Read", type: .personal, startTime: date(hour: 13, minute: 0), endTime: date(hour: 14, minute: 0)),
            Task(title: "Coding Session", type: .work, startTime: date(hour: 14, minute: 30), endTime: date(hour: 18, minute: 0)),
            Task(title: "Sleep", type: .sleep, startTime: date(hour: 23, minute: 0), endTime: date(hour: 23, minute: 59))
        ]
    }
}
