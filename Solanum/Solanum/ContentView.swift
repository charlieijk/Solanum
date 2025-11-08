//
//  ContentView.swift
//  Solanum
//
//  Enhanced Pomodoro Timer with Advanced Features
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TimerViewModel()
    @State private var showSettings = false
    @State private var showAnalytics = false
    @State private var showHistory = false

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: gradientColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                // MARK: - Header
                HStack {
                    Button(action: { showAnalytics = true }) {
                        Image(systemName: "chart.bar.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }

                    Spacer()

                    Text(viewModel.sessionType.emoji)
                        .font(.system(size: 50))

                    Spacer()

                    Button(action: { showSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                .padding(.top)

                // MARK: - Session Type
                Text(viewModel.sessionType.rawValue)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                // MARK: - Timer Circle
                ZStack {
                    // Progress Ring
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 15)
                        .frame(width: 280, height: 280)

                    Circle()
                        .trim(from: 0, to: viewModel.progress)
                        .stroke(
                            Color.white,
                            style: StrokeStyle(lineWidth: 15, lineCap: .round)
                        )
                        .frame(width: 280, height: 280)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 1), value: viewModel.progress)

                    // Timer Text
                    VStack(spacing: 10) {
                        Text(viewModel.timeString)
                            .font(.system(size: 60, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .monospacedDigit()

                        if let project = viewModel.currentProject {
                            Text(project)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                }

                // MARK: - Controls
                HStack(spacing: 30) {
                    Button(action: {
                        if viewModel.isRunning {
                            viewModel.pauseTimer()
                        } else {
                            viewModel.startTimer()
                        }
                    }) {
                        Image(systemName: viewModel.isRunning ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 70))
                            .foregroundColor(.white)
                    }

                    Button(action: {
                        viewModel.skipSession()
                    }) {
                        Image(systemName: "forward.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .padding(.vertical)

                // MARK: - Stats Cards
                HStack(spacing: 15) {
                    StatsCard(
                        title: "Today",
                        value: "\(viewModel.todaysSessionCount)",
                        icon: "checkmark.circle.fill"
                    )

                    StatsCard(
                        title: "Focus Time",
                        value: "\(viewModel.todaysFocusMinutes)m",
                        icon: "clock.fill"
                    )

                    StatsCard(
                        title: "Until Long",
                        value: "\(viewModel.sessionsUntilLongBreak)",
                        icon: "moon.fill"
                    )
                }
                .padding(.horizontal)

                // MARK: - Action Buttons
                HStack(spacing: 15) {
                    ActionButton(title: "History", icon: "list.bullet") {
                        showHistory = true
                    }

                    ActionButton(title: "Projects", icon: "folder.fill") {
                        // Project picker handled in sheet
                    }
                }
                .padding(.horizontal)

                Spacer()
            }

            // MARK: - Celebration Overlay
            if viewModel.showCelebration {
                CelebrationView()
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(viewModel: viewModel)
        }
        .sheet(isPresented: $showAnalytics) {
            AnalyticsView(viewModel: viewModel)
        }
        .sheet(isPresented: $showHistory) {
            HistoryView(viewModel: viewModel)
        }
    }

    private var gradientColors: [Color] {
        switch viewModel.sessionType {
        case .focus:
            return [Color(red: 0.9, green: 0.3, blue: 0.3), Color(red: 0.8, green: 0.2, blue: 0.2)]
        case .shortBreak:
            return [Color(red: 0.2, green: 0.6, blue: 0.9), Color(red: 0.1, green: 0.4, blue: 0.8)]
        case .longBreak:
            return [Color(red: 0.5, green: 0.3, blue: 0.8), Color(red: 0.4, green: 0.2, blue: 0.7)]
        }
    }
}

// MARK: - Supporting Views
struct StatsCard: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.white.opacity(0.8))

            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(15)
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white.opacity(0.2))
            .cornerRadius(12)
        }
    }
}

struct CelebrationView: View {
    var body: some View {
        VStack {
            Text("🎉")
                .font(.system(size: 100))
            Text("Session Complete!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.4))
    }
}

struct HistoryView: View {
    @ObservedObject var viewModel: TimerViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.todaysSessions.reversed()) { session in
                    HStack {
                        Text(session.sessionType.emoji)
                            .font(.title2)

                        VStack(alignment: .leading) {
                            Text(session.sessionType.rawValue)
                                .font(.headline)

                            if let project = session.projectName {
                                Text(project)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Text(session.startTime, style: .time)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        if session.isCompleted {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    .padding(.vertical, 5)
                }
            }
            .navigationTitle("Today's Sessions")
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

#Preview {
    ContentView()
}
