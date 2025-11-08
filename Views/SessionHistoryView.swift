//
//  SessionHistoryView.swift
//  Solanum
//
//  Created by Claude on 11/08/2025.
//

import SwiftUI

struct SessionHistoryView: View {
    @ObservedObject var viewModel: TimerViewModel
    @Environment(\.dismiss) var dismiss

    var groupedSessions: [Date: [PomodoroSession]] {
        Dictionary(grouping: viewModel.completedSessions) { session in
            Calendar.current.startOfDay(for: session.startTime)
        }
    }

    var sortedDates: [Date] {
        groupedSessions.keys.sorted(by: >)
    }

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

                if viewModel.completedSessions.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(sortedDates, id: \.self) { date in
                                sessionSection(for: date)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Session History")
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

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock.badge.questionmark")
                .font(.system(size: 60))
                .foregroundColor(.purple.opacity(0.5))

            Text("No Sessions Yet")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text("Complete your first Pomodoro session\nto see your history here")
                .font(.subheadline)
                .foregroundColor(.purple.opacity(0.7))
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Session Section

    private func sessionSection(for date: Date) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Date Header
            Text(dateString(from: date))
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 4)

            // Sessions for this date
            if let sessions = groupedSessions[date] {
                ForEach(sessions) { session in
                    SessionRow(session: session)
                }
            }
        }
    }

    // MARK: - Helper Methods

    private func dateString(from date: Date) -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()

        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else if calendar.isDate(date, equalTo: Date(), toGranularity: .weekOfYear) {
            formatter.dateFormat = "EEEE"
            return formatter.string(from: date)
        } else {
            formatter.dateFormat = "MMMM d, yyyy"
            return formatter.string(from: date)
        }
    }
}

// MARK: - Session Row

struct SessionRow: View {
    let session: PomodoroSession

    var body: some View {
        HStack(spacing: 12) {
            // Session Type Indicator
            ZStack {
                Circle()
                    .fill(sessionColor.opacity(0.2))
                    .frame(width: 44, height: 44)

                Text(session.sessionType.emoji)
                    .font(.title3)
            }

            // Session Info
            VStack(alignment: .leading, spacing: 4) {
                Text(session.projectName ?? "No Project")
                    .font(.headline)
                    .foregroundColor(.white)

                HStack(spacing: 8) {
                    Text(timeString)
                        .font(.caption)
                        .foregroundColor(.purple.opacity(0.7))

                    Text("•")
                        .foregroundColor(.purple.opacity(0.5))

                    Text("\(session.durationInMinutes) min")
                        .font(.caption)
                        .foregroundColor(.purple.opacity(0.7))

                    if session.isCompleted {
                        Text("•")
                            .foregroundColor(.purple.opacity(0.5))

                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(.green.opacity(0.8))
                    }
                }
            }

            Spacer()

            // Session Type Badge
            Text(session.sessionType.rawValue)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(sessionColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(sessionColor.opacity(0.2))
                .cornerRadius(8)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }

    private var sessionColor: Color {
        switch session.sessionType {
        case .focus:
            return .purple
        case .shortBreak:
            return .blue
        case .longBreak:
            return .pink
        }
    }

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: session.startTime)
    }
}

// MARK: - Preview

#Preview {
    SessionHistoryView(viewModel: {
        let vm = TimerViewModel()
        vm.completedSessions = PomodoroSession.sampleSessions
        return vm
    }())
}
