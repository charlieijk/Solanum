# Solanum Setup & Features Guide

## New Features Added

This branch includes the following new features:

### 1. Local Notifications
- Receive notifications when Pomodoro sessions complete
- Automatic notification permission request on first launch
- Session-specific notification messages

### 2. Haptic Feedback
- Tactile feedback when starting/pausing sessions
- Completion haptics when sessions finish
- Skip session feedback

### 3. Session History View
- View all completed Pomodoro sessions
- Organized by day (Today, Yesterday, specific dates)
- Shows project names, duration, and completion status
- Beautiful empty state when no sessions exist

### 4. Settings View
- Customize timer durations:
  - Focus session (1-60 minutes, default: 25)
  - Short break (1-30 minutes, default: 5)
  - Long break (5-60 minutes, default: 15)
- Automation options:
  - Auto-start breaks after focus sessions
  - Auto-start focus sessions after breaks
- Preferences:
  - Sound effects toggle
  - Notifications toggle
- Reset to default settings option

### 5. Enhanced UI
- Navigation bar with quick access to History and Settings
- Improved visual hierarchy
- Consistent purple/pink gradient theme

## Running the Application

### Prerequisites

- **macOS** 13.0 (Ventura) or later
- **Xcode** 15.0 or later
- **iOS Simulator** or **Physical Device** running iOS 16.0+

### Steps to Run

1. **Open the project in Xcode:**
   ```bash
   cd /path/to/Solanum
   open Solanum.xcodeproj
   ```

2. **Select a target:**
   - In Xcode, click the device selector near the top
   - Choose an iOS simulator (recommended: iPhone 15 Pro)
   - Or connect a physical iOS device

3. **Build and run:**
   - Press `Cmd + R` or click the Play ▶️ button
   - Wait for the app to compile and launch

4. **Grant permissions:**
   - On first launch, you'll be prompted to allow notifications
   - Tap "Allow" to enable session completion notifications

### Testing the App

1. **Start a Pomodoro session:**
   - Tap "Start" on the main screen
   - Feel the haptic feedback
   - Optionally select a project to tag your work

2. **Explore the UI:**
   - Tap the history icon (top left) to view past sessions
   - Tap the settings icon (top right) to customize durations
   - Watch the circular progress indicator

3. **Test notifications:**
   - Start a short session (or reduce duration in Settings)
   - Lock your device or switch to another app
   - Wait for the session to complete
   - You'll receive a notification!

## Project Structure

```
Solanum/
├── Models/
│   └── SolanumSession.swift          # Session data model
├── ViewModels/
│   └── TimerViewModel.swift          # Business logic with notifications & haptics
├── Views/
│   ├── TimerView.swift               # Main timer interface
│   ├── SessionHistoryView.swift      # Session history display
│   └── SettingsView.swift            # Settings configuration
├── Services/
│   ├── NotificationManager.swift     # Notification handling
│   └── HapticManager.swift           # Haptic feedback
├── Solanum/
│   └── SolanumApp.swift              # App entry point
└── ContentView.swift                 # Root view
```

## File Breakdown

### Core Files

- **SolanumApp.swift**: App entry point that displays ContentView
- **ContentView.swift**: Wrapper that displays TimerView
- **SolanumSession.swift**: Data model for Pomodoro sessions with Codable support
- **TimerViewModel.swift**: Main business logic including timer management, session tracking, and persistence

### New Feature Files

- **NotificationManager.swift**: Handles notification permissions and scheduling
- **HapticManager.swift**: Provides haptic feedback for various timer events
- **SessionHistoryView.swift**: UI for viewing completed sessions organized by date
- **SettingsView.swift**: Customization interface for timer durations and app preferences
- **TimerView.swift**: Enhanced main interface with navigation to history and settings

## Troubleshooting

### Notifications Not Working

1. Check Settings → Solanum → Notifications
2. Ensure notifications are enabled in the app's Settings view
3. Try restarting the app

### Build Errors

1. Clean build folder: `Cmd + Shift + K`
2. Restart Xcode
3. Ensure you're using Xcode 15.0 or later
4. Check that iOS Deployment Target is set to iOS 16.0

### App Won't Launch

1. Check the selected simulator/device is running
2. Try a different simulator
3. Check Console for error messages

## Next Steps

With these features in place, you can now:

1. **Add sound effects** - Integrate audio files for session completion
2. **Implement GitHub integration** - Connect to GitHub API for analytics
3. **Add charts** - Use Swift Charts for visualization
4. **Create widgets** - iOS home screen widgets for quick timer access
5. **iCloud sync** - Sync sessions across devices

## Development Tips

### Making Changes

1. Edit files in Xcode or your preferred editor
2. Build and run to see changes (`Cmd + R`)
3. Use SwiftUI previews for rapid iteration:
   ```swift
   #Preview {
       SettingsView(viewModel: TimerViewModel())
   }
   ```

### Testing on Device

1. Connect iPhone/iPad via USB
2. Select it in Xcode's device selector
3. Trust the computer on your device
4. Build and run (may require signing with Apple ID)

## Known Limitations

- Currently running on **Linux** environment - you'll need **macOS with Xcode** to build and run
- GitHub integration not yet implemented (planned for Phase 2)
- No background timer support yet
- Sound effects not implemented

## Support

For issues or questions:
- Check the main [README.md](README.md)
- Review code comments in source files
- Open an issue on GitHub

---

**Happy coding with Solanum!** 🍅
