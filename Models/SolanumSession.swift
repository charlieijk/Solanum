//
//  PomodoroSession.swift
//  Solanum
//
//  Created by Charlie on 11/04/2025.
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
}

// MARK: - Pomodoro Session
struct PomodoroSession: Identifiable, Codable {
    let id: UUID
    let startTime: Date
    var endTime: Date?
    var projectName: String?
    var repositoryURL: String?
    var isCompleted: Bool
    let sessionType: SessionType
    
    init(
        id: UUID = UUID(),
        startTime: Date = Date(),
        endTime: Date? = nil,
        projectName: String? = nil,
        repositoryURL: String? = nil,
        isCompleted: Bool = false,
        sessionType: SessionType = .focus
    ) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.projectName = projectName
        self.repositoryURL = repositoryURL
        self.isCompleted = isCompleted
        self.sessionType = sessionType
    }
    
    // MARK: - Computed Properties
    
    var duration: TimeInterval {
        guard let endTime = endTime else {
            return Date().timeIntervalSince(startTime)
        }
        return endTime.timeIntervalSince(startTime)
    }
    
    var durationInMinutes: Int {
        return Int(duration / 60)
    }
    
    var isActive: Bool {
        return endTime == nil
    }
    
    // MARK: - Methods
    
    mutating func complete() {
        self.endTime = Date()
        self.isCompleted = true
    }
    
    mutating func setProject(name: String, url: String? = nil) {
        self.projectName = name
        self.repositoryURL = url
    }
}

// MARK: - Sample Data (for previews)
extension PomodoroSession {
    static var sampleSessions: [PomodoroSession] {
        [
            PomodoroSession(
                startTime: Date().addingTimeInterval(-3600),
                endTime: Date().addingTimeInterval(-2100),
                projectName: "BitTorrent",
                repositoryURL: "https://github.com/charlieijk/BitTorrent",
                isCompleted: true,
                sessionType: .focus
            ),
            PomodoroSession(
                startTime: Date().addingTimeInterval(-2100),
                endTime: Date().addingTimeInterval(-1800),
                isCompleted: true,
                sessionType: .shortBreak
            ),
            PomodoroSession(
                startTime: Date().addingTimeInterval(-1800),
                endTime: Date().addingTimeInterval(-300),
                projectName: "ApiGateway",
                isCompleted: true,
                sessionType: .focus
            ),
            PomodoroSession(
                startTime: Date(),
                projectName: "Solanum",
                isCompleted: false,
                sessionType: .focus
            )
        ]
    }
}
