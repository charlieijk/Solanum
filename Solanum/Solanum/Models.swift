//
//  Models.swift
//  Solanum
//

import Foundation

// MARK: - Session Type
enum SessionType: String, Codable, CaseIterable {
    case focus = "Focus"
    case shortBreak = "Short Break"
    case longBreak = "Long Break"
    
    var duration: TimeInterval {
        switch self {
        case .focus: return 25 * 60  // 25 minutes
        case .shortBreak: return 5 * 60  // 5 minutes
        case .longBreak: return 15 * 60  // 15 minutes
        }
    }
    
    var emoji: String {
        switch self {
        case .focus: return "🍅"
        case .shortBreak: return "☕️"
        case .longBreak: return "🌙"
        }
    }
    
    var color: String {
        switch self {
        case .focus: return "tomato"
        case .shortBreak: return "coffee"
        case .longBreak: return "moon"
        }
    }
}

// MARK: - Pomodoro Session
struct PomodoroSession: Identifiable, Codable {
    let id: UUID
    let startTime: Date
    var endTime: Date?
    var projectName: String?
    var isCompleted: Bool
    let sessionType: SessionType
    
    init(
        id: UUID = UUID(),
        startTime: Date = Date(),
        endTime: Date? = nil,
        projectName: String? = nil,
        isCompleted: Bool = false,
        sessionType: SessionType = .focus
    ) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.projectName = projectName
        self.isCompleted = isCompleted
        self.sessionType = sessionType
    }
    
    var duration: TimeInterval {
        guard let endTime = endTime else {
            return Date().timeIntervalSince(startTime)
        }
        return endTime.timeIntervalSince(startTime)
    }
    
    var durationInMinutes: Int {
        return Int(duration / 60)
    }
    
    mutating func complete() {
        self.endTime = Date()
        self.isCompleted = true
    }
    
    mutating func setProject(name: String) {
        self.projectName = name
    }
}
