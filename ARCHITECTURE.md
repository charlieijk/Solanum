# Solanum Architecture

## App Flow

```
┌─────────────────────────────────────────────────────────────┐
│                       SolanumApp.swift                       │
│                    (App Entry Point)                         │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                      ContentView.swift                       │
│                  (Main Timer Interface)                      │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  • Gradient Background (changes per session type)    │  │
│  │  • Header with Project Selector                      │  │
│  │  • Circular Timer with Progress Ring                 │  │
│  │  • Start/Pause & Skip Buttons                        │  │
│  │  • Statistics Cards (3 metrics)                      │  │
│  │  • History Button                                    │  │
│  └──────────────────────────────────────────────────────┘  │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ observes
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                   TimerViewModel.swift                       │
│                  (@MainActor ObservableObject)               │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Published State:                                    │  │
│  │    • timeRemaining: TimeInterval                     │  │
│  │    • isRunning: Bool                                 │  │
│  │    • currentSession: PomodoroSession?                │  │
│  │    • sessionType: SessionType                        │  │
│  │    • completedSessions: [PomodoroSession]            │  │
│  │    • sessionsUntilLongBreak: Int                     │  │
│  │                                                       │  │
│  │  Methods:                                            │  │
│  │    • startTimer()                                    │  │
│  │    • pauseTimer()                                    │  │
│  │    • skipSession()                                   │  │
│  │    • resetTimer()                                    │  │
│  │    • setProject(name:)                               │  │
│  │                                                       │  │
│  │  Computed Properties:                                │  │
│  │    • progress: Double                                │  │
│  │    • timeString: String                              │  │
│  │    • todaysSessions: [PomodoroSession]               │  │
│  │    • todaysFocusTime: TimeInterval                   │  │
│  │    • todaysFocusMinutes: Int                         │  │
│  │    • todaysSessionCount: Int                         │  │
│  └──────────────────────────────────────────────────────┘  │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ uses
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                       Models.swift                           │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  SessionType (enum)                                  │  │
│  │    • focus: 25 minutes                               │  │
│  │    • shortBreak: 5 minutes                           │  │
│  │    • longBreak: 15 minutes                           │  │
│  │    • emoji, color, duration properties               │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  PomodoroSession (struct)                            │  │
│  │    • id: UUID                                        │  │
│  │    • startTime: Date                                 │  │
│  │    • endTime: Date?                                  │  │
│  │    • projectName: String?                            │  │
│  │    • isCompleted: Bool                               │  │
│  │    • sessionType: SessionType                        │  │
│  │    • complete(), setProject() methods                │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow

```
User Action → ContentView → TimerViewModel → Models
                    ↑            ↓
                    └────────────┘
                   (State Updates)
```

## Session Cycle

```
┌──────────┐     ┌──────────────┐     ┌──────────┐
│  Focus   │────▶│ Short Break  │────▶│  Focus   │
│ 25 min   │     │   5 min      │     │ 25 min   │
└──────────┘     └──────────────┘     └──────────┘
     │                                      │
     │                                      ▼
     │           ┌──────────────┐     ┌──────────┐
     │           │ Long Break   │◀────│  Focus   │
     │           │  15 min      │     │ 25 min   │
     │           └──────────────┘     └──────────┘
     │                 ▲                    │
     └─────────────────┴────────────────────┘
          (After 4 focus sessions)
```

## Persistence

```
┌────────────────────┐
│  TimerViewModel    │
└─────────┬──────────┘
          │
          │ save/load
          ▼
┌────────────────────┐
│  UserDefaults      │
│  "completedSessions"│
└────────────────────┘
```

## UI Components Breakdown

```
ContentView
├── backgroundGradient (dynamic based on session type)
├── headerView
│   ├── "Solanum" title
│   └── Project selector button → ProjectPickerView (sheet)
├── circularTimer
│   ├── Background circle (white 20% opacity)
│   ├── Progress circle (white, animated)
│   └── Timer info
│       ├── Time display (MM:SS)
│       └── Session type (emoji + name)
├── controlButtons
│   ├── Start/Pause button
│   └── Skip button
├── statsCards
│   ├── Sessions count
│   ├── Focus time
│   └── Until break counter
└── historyButton → HistoryView (sheet)
```

## Key Design Patterns

1. **MVVM**: Separation of View (ContentView) and ViewModel (TimerViewModel)
2. **Observable State**: Using @Published and @StateObject for reactive UI
3. **Composition**: Breaking UI into reusable components (StatCard, etc.)
4. **Persistence**: UserDefaults for session history storage
5. **Timer Management**: Foundation Timer with MainActor for thread safety

## Thread Safety

All timer operations run on @MainActor to ensure UI updates happen on the main thread:
```swift
Task { @MainActor in
    self?.tick()
}
```
