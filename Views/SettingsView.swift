//
//  SettingsView.swift
//  Solanum
//
//  Created by Claude on 11/08/2025.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: TimerViewModel
    @Environment(\.dismiss) var dismiss

    @AppStorage("focusDuration") private var focusDuration: Double = 25
    @AppStorage("shortBreakDuration") private var shortBreakDuration: Double = 5
    @AppStorage("longBreakDuration") private var longBreakDuration: Double = 15
    @AppStorage("autoStartBreaks") private var autoStartBreaks: Bool = false
    @AppStorage("autoStartPomodoros") private var autoStartPomodoros: Bool = false
    @AppStorage("soundEnabled") private var soundEnabled: Bool = true
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true

    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color(red: 0.06, green: 0.09, blue: 0.16),
                        Color(red: 0.47, green: 0.15, blue: 0.52).opacity(0.3),
                        Color(red: 0.06, green: 0.09, blue: 0.16)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Timer Durations Section
                        timerDurationsSection

                        // Automation Section
                        automationSection

                        // Preferences Section
                        preferencesSection

                        // About Section
                        aboutSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.purple)
                }
            }
        }
    }

    // MARK: - Timer Durations Section

    private var timerDurationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Timer Durations", icon: "timer")

            VStack(spacing: 16) {
                DurationSlider(
                    title: "Focus",
                    emoji: "🍅",
                    value: $focusDuration,
                    range: 1...60
                )

                DurationSlider(
                    title: "Short Break",
                    emoji: "☕️",
                    value: $shortBreakDuration,
                    range: 1...30
                )

                DurationSlider(
                    title: "Long Break",
                    emoji: "🌙",
                    value: $longBreakDuration,
                    range: 5...60
                )
            }
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
    }

    // MARK: - Automation Section

    private var automationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Automation", icon: "gearshape.2")

            VStack(spacing: 0) {
                SettingsToggle(
                    title: "Auto-start Breaks",
                    description: "Automatically start breaks after focus sessions",
                    isOn: $autoStartBreaks
                )

                Divider()
                    .background(Color.white.opacity(0.1))
                    .padding(.horizontal)

                SettingsToggle(
                    title: "Auto-start Pomodoros",
                    description: "Automatically start focus sessions after breaks",
                    isOn: $autoStartPomodoros
                )
            }
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
    }

    // MARK: - Preferences Section

    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Preferences", icon: "slider.horizontal.3")

            VStack(spacing: 0) {
                SettingsToggle(
                    title: "Sound Effects",
                    description: "Play sound when timer completes",
                    isOn: $soundEnabled
                )

                Divider()
                    .background(Color.white.opacity(0.1))
                    .padding(.horizontal)

                SettingsToggle(
                    title: "Notifications",
                    description: "Show notifications when timer completes",
                    isOn: $notificationsEnabled
                )
            }
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
    }

    // MARK: - About Section

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "About", icon: "info.circle")

            VStack(spacing: 12) {
                HStack {
                    Text("Version")
                        .foregroundColor(.white)
                    Spacer()
                    Text("0.1.0-alpha")
                        .foregroundColor(.purple.opacity(0.7))
                }

                Divider()
                    .background(Color.white.opacity(0.1))

                HStack {
                    Text("Developer")
                        .foregroundColor(.white)
                    Spacer()
                    Text("@charlieijk")
                        .foregroundColor(.purple.opacity(0.7))
                }

                Divider()
                    .background(Color.white.opacity(0.1))

                Button(action: {
                    // Reset all settings to default
                    focusDuration = 25
                    shortBreakDuration = 5
                    longBreakDuration = 15
                    autoStartBreaks = false
                    autoStartPomodoros = false
                    soundEnabled = true
                    notificationsEnabled = true
                }) {
                    HStack {
                        Text("Reset to Defaults")
                            .foregroundColor(.red.opacity(0.8))
                        Spacer()
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundColor(.red.opacity(0.8))
                    }
                }
            }
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
    }

    // MARK: - Helper Views

    private func sectionHeader(title: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundColor(.purple.opacity(0.7))

            Text(title)
                .font(.headline)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Duration Slider

struct DurationSlider: View {
    let title: String
    let emoji: String
    @Binding var value: Double
    let range: ClosedRange<Double>

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(emoji)
                    .font(.title3)

                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.white)

                Spacer()

                Text("\(Int(value)) min")
                    .font(.headline)
                    .foregroundColor(.purple)
                    .monospacedDigit()
            }

            Slider(value: $value, in: range, step: 1)
                .accentColor(.purple)
        }
    }
}

// MARK: - Settings Toggle

struct SettingsToggle: View {
    let title: String
    let description: String
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.white)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.purple.opacity(0.6))
            }
        }
        .toggleStyle(SwitchToggleStyle(tint: .purple))
    }
}

// MARK: - Preview

#Preview {
    SettingsView(viewModel: TimerViewModel())
}
