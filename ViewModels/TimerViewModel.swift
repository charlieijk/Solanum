//
//  TimerViewModel.swift
//  Solanum
//
//  Created by Charlie on 11/04/2025.
//

import Foundation
import Combine

@MainActor
class TimerViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var timeRemaining: TimeInterval = 25 * 60  // Default 25 minutes
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
        todaysSessions.filter { $0.sessionType == .focus }.count
    }
    
    // MARK: - Initialization
    
    init() {
        loadSessions()
    }
    
    // MARK: - Timer Control Methods
    
    func startTimer() {
        guard !isRunning else { return }
        
        // Create new session if needed
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
        
        // Play completion sound (TODO: Add sound)
        // Send notification (TODO: Add notification)
        
        completeCurrentSession(forced: false)
        prepareNextSession()
    }
    
    private func completeCurrentSession(forced: Bool) {
        guard var session = currentSession else { return }
        
        if !forced {
            session.complete()
            completedSessions.append(session)
            saveSessions()
            
            // Increment session count for long break tracking
            if session.sessionType == .focus {
                sessionCount += 1
            }
        }
        
        currentSession = nil
    }
    
    private func prepareNextSession() {
        // Determine next session type
        if sessionType == .focus {
            // After a focus session, take a break
            if sessionCount % 4 == 0 {
                sessionType = .longBreak
                sessionsUntilLongBreak = 4
            } else {
                sessionType = .shortBreak
                sessionsUntilLongBreak = 4 - (sessionCount % 4)
            }
        } else {
            // After a break, focus again
            sessionType = .focus
        }
        
        timeRemaining = sessionType.duration
    }
    
    // MARK: - Session Management
    
    func setProject(name: String, url: String? = nil) {
        currentSession?.setProject(name: name, url: url)
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
            
            // Calculate session count for today
            sessionCount = todaysSessions.filter { $0.sessionType == .focus }.count
            sessionsUntilLongBreak = 4 - (sessionCount % 4)
        }
    }
    
    // MARK: - Settings
    
    func updateDuration(for type: SessionType, minutes: Int) {
        // TODO: Implement custom durations
        // Will store in UserDefaults and update SessionType.duration
    }
}
