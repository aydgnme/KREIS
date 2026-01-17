//
//  Task.swift
//  KREIS
//
//  Created by Mert Aydogan on 17.01.2026.
//

import UIKit

// MARK: - Task Type

enum TaskType {
    case work
    case personal
    case sleep
    case routine
    
    /// Bauhaus colours
    var color: UIColor {
        switch self {
        case .work: return .kreisBlue
        case .personal: return .kreisRed
        case .sleep: return .kreisBlack.withAlphaComponent(0.3)
        case .routine: return .kreisYellow
        }
    }
}

// MARK: - Task Model

struct Task: Identifiable {
    let id = UUID()
    let title: String
    let type: TaskType
    let startTime: Date
    let endTime: Date
    
    /// Helper: Convert to minutes
    var durationInMinutes: Double {
        return endTime.timeIntervalSince(startTime) / 60
    }

}
