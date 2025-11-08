//
//  AnalyticsView.swift
//  Solanum
//
//  Advanced analytics and productivity insights
//

import SwiftUI
import Charts

struct AnalyticsView: View {
    @ObservedObject var viewModel: TimerViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var selectedTimeRange: TimeRange = .week

    enum TimeRange: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case all = "All Time"
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // MARK: - Time Range Picker
                    Picker("Time Range", selection: $selectedTimeRange) {
                        ForEach(TimeRange.allCases, id: \.self) { range in
                            Text(range.rawValue).tag(range)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    // MARK: - Summary Cards
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        StatCard(
                            title: "Total Sessions",
                            value: "\(filteredSessions.count)",
                            icon: "list.number",
                            color: .blue
                        )

                        StatCard(
                            title: "Focus Time",
                            value: "\(totalFocusMinutes) min",
                            icon: "clock.fill",
                            color: .orange
                        )

                        StatCard(
                            title: "Avg Session",
                            value: String(format: "%.1f min", averageSessionDuration),
                            icon: "chart.bar.fill",
                            color: .green
                        )

                        StatCard(
                            title: "Streak",
                            value: "\(currentStreak) days",
                            icon: "flame.fill",
                            color: .red
                        )
                    }
                    .padding(.horizontal)

                    // MARK: - Weekly Chart
                    if #available(iOS 16.0, *) {
                        VStack(alignment: .leading) {
                            Text("Sessions Per Day")
                                .font(.headline)
                                .padding(.horizontal)

                            Chart {
                                ForEach(weeklyData, id: \.date) { data in
                                    BarMark(
                                        x: .value("Day", data.dayName),
                                        y: .value("Sessions", data.count)
                                    )
                                    .foregroundStyle(Color.blue.gradient)
                                }
                            }
                            .frame(height: 200)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    }

                    // MARK: - Project Breakdown
                    VStack(alignment: .leading) {
                        Text("Top Projects")
                            .font(.headline)
                            .padding(.horizontal)

                        ForEach(topProjects, id: \.name) { project in
                            ProjectRow(
                                name: project.name,
                                sessions: project.count,
                                percentage: Double(project.count) / Double(filteredSessions.count)
                            )
                        }
                        .padding(.horizontal)
                    }

                    // MARK: - Productivity Insights
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Insights")
                            .font(.headline)
                            .padding(.horizontal)

                        InsightCard(
                            icon: "chart.line.uptrend.xyaxis",
                            text: productivityTrend,
                            color: .blue
                        )

                        InsightCard(
                            icon: "star.fill",
                            text: bestDay,
                            color: .yellow
                        )

                        InsightCard(
                            icon: "target",
                            text: completionRate,
                            color: .green
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Analytics")
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

    // MARK: - Computed Properties
    private var filteredSessions: [PomodoroSession] {
        let calendar = Calendar.current
        let now = Date()

        switch selectedTimeRange {
        case .week:
            let weekAgo = calendar.date(byAdding: .day, value: -7, to: now)!
            return viewModel.completedSessions.filter { $0.startTime > weekAgo }
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now)!
            return viewModel.completedSessions.filter { $0.startTime > monthAgo }
        case .all:
            return viewModel.completedSessions
        }
    }

    private var totalFocusMinutes: Int {
        filteredSessions
            .filter { $0.sessionType == .focus && $0.isCompleted }
            .reduce(0) { $0 + $1.durationInMinutes }
    }

    private var averageSessionDuration: Double {
        guard !filteredSessions.isEmpty else { return 0 }
        let total = filteredSessions.reduce(0.0) { $0 + $1.duration }
        return (total / Double(filteredSessions.count)) / 60
    }

    private var currentStreak: Int {
        let calendar = Calendar.current
        var streak = 0
        var currentDate = Date()

        while true {
            let sessionsOnDate = viewModel.completedSessions.filter {
                calendar.isDate($0.startTime, inSameDayAs: currentDate)
            }

            if sessionsOnDate.isEmpty {
                break
            }

            streak += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDate) else { break }
            currentDate = previousDay
        }

        return streak
    }

    private var weeklyData: [(date: Date, dayName: String, count: Int)] {
        let calendar = Calendar.current
        let now = Date()

        return (0..<7).map { dayOffset in
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: now) else {
                return (Date(), "", 0)
            }

            let formatter = DateFormatter()
            formatter.dateFormat = "EEE"
            let dayName = formatter.string(from: date)

            let count = viewModel.completedSessions.filter {
                calendar.isDate($0.startTime, inSameDayAs: date) && $0.sessionType == .focus
            }.count

            return (date, dayName, count)
        }.reversed()
    }

    private var topProjects: [(name: String, count: Int)] {
        let projectCounts = Dictionary(grouping: filteredSessions.compactMap { $0.projectName }) { $0 }
            .mapValues { $0.count }
            .sorted { $0.value > $1.value }

        return Array(projectCounts.prefix(5)).map { (name: $0.key, count: $0.value) }
    }

    private var productivityTrend: String {
        let recentSessions = filteredSessions.suffix(10).count
        let olderSessions = filteredSessions.dropLast(10).suffix(10).count

        if recentSessions > olderSessions {
            return "You're on an upward trend! Recent sessions increased by \((recentSessions - olderSessions)) compared to earlier."
        } else if recentSessions < olderSessions {
            return "Productivity has dipped slightly. Consider adjusting your schedule."
        } else {
            return "Your productivity is steady. Keep up the consistent work!"
        }
    }

    private var bestDay: String {
        let dayGroups = Dictionary(grouping: filteredSessions) {
            Calendar.current.component(.weekday, from: $0.startTime)
        }

        guard let bestDay = dayGroups.max(by: { $0.value.count < $1.value.count }) else {
            return "Complete more sessions to see your best day!"
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let dayName = formatter.weekdaySymbols[bestDay.key - 1]

        return "Your most productive day is \(dayName) with \(bestDay.value.count) sessions!"
    }

    private var completionRate: String {
        guard !filteredSessions.isEmpty else {
            return "No sessions yet to calculate completion rate."
        }

        let completed = filteredSessions.filter { $0.isCompleted }.count
        let rate = Double(completed) / Double(filteredSessions.count) * 100

        return String(format: "%.0f%% of sessions completed successfully", rate)
    }
}

// MARK: - Supporting Views
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Spacer()
            }

            Text(value)
                .font(.title2)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ProjectRow: View {
    let name: String
    let sessions: Int
    let percentage: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(name)
                    .font(.subheadline)
                Spacer()
                Text("\(sessions) sessions")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 8)
                        .cornerRadius(4)

                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: geometry.size.width * percentage, height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
        .padding(.vertical, 5)
    }
}

struct InsightCard: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)

            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
