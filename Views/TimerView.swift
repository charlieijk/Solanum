//
//  TimerView.swift
//  Solanum
//
//  Created by Charlie on 11/04/2025.
//

import SwiftUI

struct TimerView: View {
    @StateObject private var viewModel = TimerViewModel()
    @State private var showProjectPicker = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.09, blue: 0.16),
                    Color(red: 0.47, green: 0.15, blue: 0.52),
                    Color(red: 0.06, green: 0.09, blue: 0.16)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header
                headerView
                
                // Main Timer Circle
                circularTimer
                
                // Controls
                controlButtons
                
                // Session Stats
                statsCards
                
                Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $showProjectPicker) {
            ProjectPickerView(viewModel: viewModel)
        }
    }
    
    // MARK: - Header View
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Current Session")
                .font(.subheadline)
                .foregroundColor(.purple.opacity(0.7))
            
            Button(action: { showProjectPicker = true }) {
                HStack {
                    Text(viewModel.currentSession?.projectName ?? "Select Project")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundColor(.purple.opacity(0.7))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    LinearGradient(
                        colors: [Color.purple.opacity(0.2), Color.pink.opacity(0.2)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                )
            }
        }
    }
    
    // MARK: - Circular Timer
    
    private var circularTimer: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color.white.opacity(0.1), lineWidth: 12)
                .frame(width: 280, height: 280)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: viewModel.progress)
                .stroke(
                    LinearGradient(
                        colors: [Color.purple, Color.pink],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .frame(width: 280, height: 280)
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: viewModel.progress)
            
            // Time and session info
            VStack(spacing: 12) {
                Text(viewModel.timeString)
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .monospacedDigit()
                
                HStack(spacing: 6) {
                    Text(viewModel.sessionType.emoji)
                        .font(.title3)
                    Text(viewModel.sessionType.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.purple.opacity(0.8))
                }
            }
        }
    }
    
    // MARK: - Control Buttons
    
    private var controlButtons: some View {
        HStack(spacing: 16) {
            // Start/Pause Button
            Button(action: {
                if viewModel.isRunning {
                    viewModel.pauseTimer()
                } else {
                    viewModel.startTimer()
                }
            }) {
                HStack(spacing: 10) {
                    Image(systemName: viewModel.isRunning ? "pause.fill" : "play.fill")
                        .font(.title3)
                    Text(viewModel.isRunning ? "Pause" : "Start")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [Color.purple, Color.pink],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: .purple.opacity(0.5), radius: 10, y: 5)
            }
            
            // Skip Button
            Button(action: { viewModel.skipSession() }) {
                HStack(spacing: 8) {
                    Image(systemName: "forward.fill")
                        .font(.title3)
                    Text("Skip")
                        .font(.headline)
                }
                .foregroundColor(.purple.opacity(0.8))
                .frame(width: 120)
                .padding(.vertical, 16)
                .background(Color.white.opacity(0.1))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Stats Cards
    
    private var statsCards: some View {
        HStack(spacing: 12) {
            StatCard(
                value: "\(viewModel.todaysSessionCount)",
                label: "Today's Sessions",
                icon: "flame.fill"
            )
            
            StatCard(
                value: "\(viewModel.todaysFocusMinutes)m",
                label: "Focus Time",
                icon: "clock.fill"
            )
            
            StatCard(
                value: "\(viewModel.sessionsUntilLongBreak)",
                label: "Until Long Break",
                icon: "moon.fill"
            )
        }
        .padding(.horizontal)
    }
}

// MARK: - Stat Card Component

struct StatCard: View {
    let value: String
    let label: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.purple.opacity(0.7))
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.purple.opacity(0.6))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - Project Picker View (Placeholder)

struct ProjectPickerView: View {
    @ObservedObject var viewModel: TimerViewModel
    @Environment(\.dismiss) var dismiss
    
    // Temporary project list
    let projects = ["BitTorrent", "ApiGateway", "PredictiveStockAnalysis", "Solanum", "Other"]
    
    var body: some View {
        NavigationView {
            List(projects, id: \.self) { project in
                Button(action: {
                    viewModel.setProject(name: project)
                    dismiss()
                }) {
                    HStack {
                        Text(project)
                            .foregroundColor(.primary)
                        Spacer()
                        if viewModel.currentSession?.projectName == project {
                            Image(systemName: "checkmark")
                                .foregroundColor(.purple)
                        }
                    }
                }
            }
            .navigationTitle("Select Project")
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

// MARK: - Preview

#Preview {
    TimerView()
}
