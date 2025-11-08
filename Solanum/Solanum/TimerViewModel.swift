//
//  TimerViewModel.swift
//  Solanum
//

import Foundation
import SwiftUI
internal import Combine

@MainActor
class TimerViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var timeRemaining: TimeInterval = 25 * 60
    @Published var isRunning = false
    @Published var currentSession: PomodoroSession?
    @Published var sessionType: SessionType = .focus
    @Published var completedSessions: [PomodoroSession] = []
    @Published var sessionsUntilLongBreak = 4
    @Published var currentProject: String?
    @Published var showCelebration = false

    // MARK: - Private Properties
    private var timer: Timer?
    private var sessionCount = 0
    private let soundManager = SoundManager.shared
    private let notificationManager = NotificationManager.shared
    
    // MARK: - Computed Properties
    var progress: Double {
        let totalDuration = sessionType.duration
        return 1.0 - (timeRemaining / totalDuration)
    }
    
    var timeString: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var todaysSessions: [PomodoroSession] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return completedSessions.filter { session in
            calendar.isDate(session.startTime, inSameDayAs: today)
        }
    }
    
    var todaysFocusTime: TimeInterval {
        todaysSessions
            .filter { $0.sessionType == .focus && $0.isCompleted }
            .reduce(0) { $0 + $1.duration }
    }
    
    var todaysFocusMinutes: Int {
        Int(todaysFocusTime / 60)
    }
    
    var todaysSessionCount: Int {
        todaysSessions.filter { $0.sessionType == .focus && $0.isCompleted }.count
    }
    
    // MARK: - Initialization
    init() {
        loadSessions()
    }
    
    // MARK: - Timer Control Methods
    func startTimer() {
        guard !isRunning else { return }

        if currentSession == nil {
            var session = PomodoroSession(sessionType: sessionType)
            if let project = currentProject {
                session.setProject(name: project)
            }
            currentSession = session
        }

        isRunning = true
        soundManager.playSessionStart()

        // Schedule notification for session end
        notificationManager.scheduleSessionEnd(for: sessionType, in: timeRemaining)

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
    }
    
    func pauseTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        notificationManager.cancelAllNotifications()
    }
    
    func skipSession() {
        pauseTimer()
        completeCurrentSession(forced: true)
        prepareNextSession()
    }
    
    func resetTimer() {
        pauseTimer()
        timeRemaining = sessionType.duration
        currentSession = nil
    }
    
    // MARK: - Private Methods
    private func tick() {
        guard timeRemaining > 0 else {
            sessionComplete()
            return
        }
        timeRemaining -= 1
    }
    
    private func sessionComplete() {
        pauseTimer()
        soundManager.playSessionComplete()
        showCelebration = true

        // Hide celebration after 2 seconds
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            showCelebration = false
        }

        completeCurrentSession(forced: false)
        prepareNextSession()
    }
    
    private func completeCurrentSession(forced: Bool) {
        guard var session = currentSession else { return }
        
        if !forced {
            session.complete()
            completedSessions.append(session)
            saveSessions()
            
            if session.sessionType == .focus {
                sessionCount += 1
            }
        }
        
        currentSession = nil
    }
    
    private func prepareNextSession() {
        if sessionType == .focus {
            if sessionCount % 4 == 0 {
                sessionType = .longBreak
                sessionsUntilLongBreak = 4
            } else {
                sessionType = .shortBreak
                sessionsUntilLongBreak = 4 - (sessionCount % 4)
            }
        } else {
            sessionType = .focus
        }
        
        timeRemaining = sessionType.duration
    }
    
    func setProject(name: String) {
        currentProject = name
        if var session = currentSession {
            session.setProject(name: name)
            currentSession = session
        }
    }

    func clearAllData() {
        completedSessions.removeAll()
        sessionCount = 0
        sessionsUntilLongBreak = 4
        saveSessions()
    }

    // MARK: - Advanced Analytics
    func getProductivityScore() -> Double {
        let totalSessions = completedSessions.filter { $0.isCompleted }.count
        let totalPossibleSessions = max(1, Calendar.current.dateComponents([.day], from: completedSessions.first?.startTime ?? Date(), to: Date()).day ?? 1) * 8

        return min(1.0, Double(totalSessions) / Double(totalPossibleSessions))
    }

    func getWeeklyComparison() -> (current: Int, previous: Int) {
        let calendar = Calendar.current
        let now = Date()

        let thisWeekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
        let lastWeekStart = calendar.date(byAdding: .weekOfYear, value: -1, to: thisWeekStart)!

        let thisWeek = completedSessions.filter { $0.startTime >= thisWeekStart && $0.isCompleted }.count
        let lastWeek = completedSessions.filter { $0.startTime >= lastWeekStart && $0.startTime < thisWeekStart && $0.isCompleted }.count

        return (thisWeek, lastWeek)
    }
    
    // MARK: - Persistence
    private func saveSessions() {
        if let encoded = try? JSONEncoder().encode(completedSessions) {
            UserDefaults.standard.set(encoded, forKey: "completedSessions")
        }
    }
    
    private func loadSessions() {
        if let data = UserDefaults.standard.data(forKey: "completedSessions"),
           let decoded = try? JSONDecoder().decode([PomodoroSession].self, from: data) {
            completedSessions = decoded
            sessionCount = todaysSessions.filter { $0.sessionType == .focus && $0.isCompleted }.count
            sessionsUntilLongBreak = max(1, 4 - (sessionCount % 4))
        }
    }
}
