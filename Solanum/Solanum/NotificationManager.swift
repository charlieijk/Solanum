//
//  NotificationManager.swift
//  Solanum
//
//  Manages local notifications for Pomodoro sessions
//

import Foundation
import UserNotifications
internal import Combine

@MainActor
class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    @Published var isAuthorized = false

    private init() {
        Task {
            await checkAuthorization()
        }
    }

    // MARK: - Authorization
    func requestAuthorization() async {
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])
            isAuthorized = granted
        } catch {
            print("Notification authorization error: \(error)")
            isAuthorized = false
        }
    }

    func checkAuthorization() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        isAuthorized = settings.authorizationStatus == .authorized
    }

    // MARK: - Schedule Notifications
    func scheduleSessionEnd(for sessionType: SessionType, in timeInterval: TimeInterval) {
        guard isAuthorized else { return }

        let content = UNMutableNotificationContent()
        content.title = "\(sessionType.emoji) \(sessionType.rawValue) Complete!"
        content.body = sessionType == .focus
            ? "Great work! Time for a break."
            : "Break's over. Ready to focus?"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: timeInterval,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: "session-end-\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }

    func scheduleReminder(minutes: Int, message: String) {
        guard isAuthorized else { return }

        let content = UNMutableNotificationContent()
        content.title = "⏰ Reminder"
        content.body = message
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: TimeInterval(minutes * 60),
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: "reminder-\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
