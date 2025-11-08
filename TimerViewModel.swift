//
//  TimerViewModel.swift
//  Solanum
//

import Foundation
import SwiftUI

@MainActor
class TimerViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var timeRemaining: TimeInterval = 25 * 60
    @Published var isRunning = false
    @Published var currentSession: PomodoroSession?
    @Published var sessionType: SessionType = .focus
    @Published var completedSessions: [PomodoroSession] = []
    @Published var sessionsUntilLongBreak = 4
    
    // MARK: - Private Properties
    private var timer: Timer?
    private var sessionCount = 0
    
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
            currentSession = PomodoroSession(sessionType: sessionType)
        }
        
        isRunning = true
        
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
        currentSession?.setProject(name: name)
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
