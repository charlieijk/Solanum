//
//  NotificationManager.swift
//  Solanum
//
//  Created by Claude on 11/08/2025.
//

import Foundation
import UserNotifications
import UIKit

@MainActor
class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    @Published var permissionGranted = false

    private init() {
        checkPermissionStatus()
    }

    // MARK: - Permission Management

    func requestPermission() async {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .sound, .badge]
            )
            permissionGranted = granted
        } catch {
            print("Error requesting notification permission: \(error)")
            permissionGranted = false
        }
    }

    func checkPermissionStatus() {
        Task {
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            permissionGranted = settings.authorizationStatus == .authorized
        }
    }

    // MARK: - Schedule Notifications

    func scheduleSessionCompletion(for sessionType: SessionType, in timeInterval: TimeInterval) {
        guard permissionGranted else { return }

        let content = UNMutableNotificationContent()

        switch sessionType {
        case .focus:
            content.title = "Focus Session Complete!"
            content.body = "Great work! Time for a break."
            content.sound = .default
        case .shortBreak:
            content.title = "Break Over!"
            content.body = "Ready to focus again?"
            content.sound = .default
        case .longBreak:
            content.title = "Long Break Complete!"
            content.body = "You've earned this! Time to get back to work."
            content.sound = .default
        }

        content.categoryIdentifier = "session.complete"
        content.badge = 1

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: timeInterval,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: "session.\(sessionType.rawValue).\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    func cancelSessionNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let sessionIdentifiers = requests
                .filter { $0.identifier.starts(with: "session.") }
                .map { $0.identifier }

            UNUserNotificationCenter.current().removePendingNotificationRequests(
                withIdentifiers: sessionIdentifiers
            )
        }
    }
}
