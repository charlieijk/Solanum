//
//  SettingsView.swift
//  Solanum
//
//  Settings and customization interface
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: TimerViewModel
    @StateObject private var soundManager = SoundManager.shared
    @StateObject private var notificationManager = NotificationManager.shared
    @Environment(\.dismiss) private var dismiss

    @AppStorage("customFocusDuration") private var customFocusDuration: Int = 25
    @AppStorage("customShortBreakDuration") private var customShortBreakDuration: Int = 5
    @AppStorage("customLongBreakDuration") private var customLongBreakDuration: Int = 15
    @AppStorage("sessionsBeforeLongBreak") private var sessionsBeforeLongBreak: Int = 4
    @AppStorage("autoStartNextSession") private var autoStartNextSession = false
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false

    var body: some View {
        NavigationView {
            Form {
                // MARK: - Timer Durations
                Section(header: Text("Timer Durations")) {
                    Stepper("Focus: \(customFocusDuration) min", value: $customFocusDuration, in: 1...60)
                    Stepper("Short Break: \(customShortBreakDuration) min", value: $customShortBreakDuration, in: 1...30)
                    Stepper("Long Break: \(customLongBreakDuration) min", value: $customLongBreakDuration, in: 5...60)
                    Stepper("Sessions before long break: \(sessionsBeforeLongBreak)", value: $sessionsBeforeLongBreak, in: 2...10)
                }

                // MARK: - Sound Settings
                Section(header: Text("Sound")) {
                    Toggle("Sound Effects", isOn: $soundManager.isSoundEnabled)
                        .onChange(of: soundManager.isSoundEnabled) { _, _ in
                            soundManager.saveSettings()
                        }

                    if soundManager.isSoundEnabled {
                        VStack(alignment: .leading) {
                            Text("Volume")
                            Slider(value: $soundManager.soundVolume, in: 0...1)
                                .onChange(of: soundManager.soundVolume) { _, _ in
                                    soundManager.saveSettings()
                                }
                        }
                    }
                }

                // MARK: - Notifications
                Section(header: Text("Notifications")) {
                    if notificationManager.isAuthorized {
                        Label("Notifications Enabled", systemImage: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    } else {
                        Button(action: {
                            Task {
                                await notificationManager.requestAuthorization()
                            }
                        }) {
                            Label("Enable Notifications", systemImage: "bell.badge")
                        }
                    }
                }

                // MARK: - Behavior
                Section(header: Text("Behavior")) {
                    Toggle("Auto-start next session", isOn: $autoStartNextSession)
                }

                // MARK: - Appearance
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $darkModeEnabled)
                }

                // MARK: - Data Management
                Section(header: Text("Data")) {
                    Button(role: .destructive, action: {
                        viewModel.clearAllData()
                    }) {
                        Label("Clear All History", systemImage: "trash")
                    }

                    HStack {
                        Text("Total Sessions")
                        Spacer()
                        Text("\(viewModel.completedSessions.count)")
                            .foregroundColor(.secondary)
                    }
                }

                // MARK: - About
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }

                    Link("GitHub Repository", destination: URL(string: "https://github.com/charlieijk/Solanum")!)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
