# Solanum 🍅

> **Developer Productivity Pomodoro Timer with GitHub Integration**

A beautiful iOS app that combines the Pomodoro Technique with real-time GitHub analytics to help developers stay productive and maintain consistent contributions.

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-16.0+-blue.svg)](https://www.apple.com/ios/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-4.0-green.svg)](https://developer.apple.com/xcode/swiftui/)
[![License](https://img.shields.io/badge/License-MIT-purple.svg)](LICENSE)

<p align="center">
  <img src="screenshots/hero.png" alt="Solanum App Preview" width="800">
</p>

## 🌟 Why Solanum?

The Pomodoro Technique gets its name from the Italian word for tomato 🍅. **Solanum** is the genus that includes tomatoes (*Solanum lycopersicum*), creating a clever botanical connection while giving the app a unique, memorable identity.

As developers, we often struggle with:
- **Inconsistent GitHub activity** - Breaking our contribution streaks
- **Context switching** - Jumping between projects without focus
- **Portfolio neglect** - Some repos get attention while others collect dust
- **Productivity tracking** - Not knowing where our time actually goes

Solanum solves these problems by combining focused work sessions with intelligent insights about your coding habits.

---

## ✨ Features

### 🎯 Smart Pomodoro Timer
- **25-minute focus sessions** with 5-minute breaks
- **Long breaks** (15 min) after every 4 sessions
- **Beautiful circular progress** indicator with gradient animations
- **Session tagging** - Track which project you're working on
- **Automatic transitions** between work and break periods
- **Persistent history** - Never lose track of your sessions

### 📊 GitHub Integration *(Coming Soon)*
- **Real-time statistics** from your GitHub profile
- **Language distribution** - See which languages you're using most
- **Contribution tracking** - Monitor your commit streaks
- **Repository activity** - Identify inactive projects
- **Commit patterns** - Discover your most productive times

### 🧠 Intelligent Insights *(Coming Soon)*
- **Portfolio recommendations** - "Python activity down 40% this week"
- **Streak maintenance** - Never break your contribution streak
- **Balance suggestions** - Distribute time across your projects
- **Productivity analytics** - Track focus time and session completion rates

### 📈 Analytics Dashboard *(Coming Soon)*
- **Weekly activity charts** - Visualize your coding patterns
- **Project time breakdown** - See where your hours go
- **Session history** - Review past work sessions
- **Export data** - Download your stats as CSV/JSON

---

## 📱 Screenshots

<p align="center">
  <img src="screenshots/timer.png" alt="Timer View" width="250">
  <img src="screenshots/stats.png" alt="Stats View" width="250">
  <img src="screenshots/insights.png" alt="Insights View" width="250">
</p>

*More screenshots coming soon as features are developed!*

---

## 🚀 Getting Started

### Prerequisites

- **macOS** 13.0 (Ventura) or later
- **Xcode** 15.0 or later
- **iOS 16.0+** device or simulator
- **Swift** 5.9+

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/charlieijk/Solanum.git
   cd Solanum
   ```

2. **Open in Xcode**
   ```bash
   open Solanum.xcodeproj
   ```

3. **Select your target**
   - Choose a simulator or connected device
   - Recommended: iPhone 15 Pro simulator

4. **Build and run**
   - Press `Cmd + R` or click the Play button ▶️
   - The app will launch in the simulator/device

### First Run

1. Start your first Pomodoro session
2. Tap **"Select Project"** to tag your work
3. Focus for 25 minutes
4. Take a well-deserved break!

---

## 🏗️ Project Structure

```
Solanum/
├── Models/
│   └── PomodoroSession.swift      # Data model for timer sessions
├── Views/
│   └── TimerView.swift            # Main timer interface
├── ViewModels/
│   └── TimerViewModel.swift       # Timer business logic
├── Services/                      # (Coming soon)
│   ├── GitHubAPIService.swift     # GitHub API integration
│   └── NotificationManager.swift  # Push notifications
├── Utilities/                     # (Coming soon)
│   └── Extensions.swift           # Helper extensions
└── SolanumApp.swift              # App entry point
```

---

## 🛠️ Tech Stack

- **Language:** Swift 5.9
- **UI Framework:** SwiftUI
- **Architecture:** MVVM (Model-View-ViewModel)
- **Data Persistence:** UserDefaults (Core Data planned)
- **API Integration:** GitHub REST API v3 (in progress)
- **Charts:** Swift Charts (planned)
- **Design:** Custom gradient theme with glassmorphism

---

## 🎨 Design Philosophy

Solanum features a modern, developer-friendly interface with:

- **Dark-first design** - Easy on the eyes during long coding sessions
- **Purple-pink gradients** - Energetic yet calming color scheme
- **Glassmorphism** - Frosted glass effects for depth
- **Smooth animations** - Spring-based transitions
- **SF Symbols** - Native iOS icons for consistency
- **Accessibility** - VoiceOver support and dynamic type (planned)

### Color Palette

```swift
Primary: Purple (#A855F7)
Secondary: Pink (#EC4899)
Background: Slate-900 (#0F172A)
Surface: White/5% opacity
Text: White (#FFFFFF)
```

---

## 📖 Usage

### Basic Timer Flow

```swift
1. Open app → Timer starts at 25:00
2. Tap "Start" → Timer begins counting down
3. (Optional) Tap "Select Project" → Tag your session
4. Work until timer completes → 🔔 Notification
5. Take a 5-minute break
6. Repeat 4 times → Earn a 15-minute long break
```

### Session Management

- **Pause:** Tap the pause button anytime
- **Skip:** Jump to the next session (break or focus)
- **Stats:** View today's completed sessions
- **History:** Access past sessions (coming soon)

---

## 🗺️ Roadmap

### Phase 1: MVP ✅ *Current Phase*
- [x] Basic Pomodoro timer (25/5/15)
- [x] Start/Pause/Skip controls
- [x] Session tracking
- [x] Project tagging
- [x] Today's statistics
- [x] Beautiful UI with animations

### Phase 2: GitHub Integration 🚧 *In Progress*
- [ ] GitHub OAuth authentication
- [ ] Fetch user profile and repos
- [ ] Display language distribution
- [ ] Track commit history
- [ ] Show contribution streaks
- [ ] Repository list view

### Phase 3: Analytics & Insights 📋 *Planned*
- [ ] Weekly/monthly charts
- [ ] Project time breakdown
- [ ] Intelligent recommendations
- [ ] Portfolio gap analysis
- [ ] Productivity trends
- [ ] Export data feature

### Phase 4: Polish & Advanced Features 🎯 *Future*
- [ ] Local notifications
- [ ] Background timer support
- [ ] Sound effects and haptics
- [ ] Custom timer durations
- [ ] Dark/light mode toggle
- [ ] iPad optimization
- [ ] Widgets (iOS 17+)
- [ ] Apple Watch companion app
- [ ] Siri shortcuts
- [ ] iCloud sync

---

## 🤝 Contributing

Contributions are welcome! Whether it's:

- 🐛 Bug reports
- 💡 Feature suggestions
- 📝 Documentation improvements
- 🎨 UI/UX enhancements
- 🧪 Testing and feedback

### How to Contribute

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Commit your changes**
   ```bash
   git commit -m "Add some amazing feature"
   ```
4. **Push to your branch**
   ```bash
   git push origin feature/amazing-feature
   ```
5. **Open a Pull Request**

### Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/Solanum.git

# Create a branch
git checkout -b feature/my-new-feature

# Make your changes and test
# Open Solanum.xcodeproj in Xcode

# Commit and push
git add .
git commit -m "Description of changes"
git push origin feature/my-new-feature
```

---

## 📊 GitHub Stats Integration

### API Endpoints Used

```
Base URL: https://api.github.com

- GET /users/{username}              # User profile
- GET /users/{username}/repos        # Repository list
- GET /repos/{owner}/{repo}/commits  # Commit history
- GET /repos/{owner}/{repo}/languages # Language stats
- GET /users/{username}/events       # Activity feed
```

### Rate Limits

- **Unauthenticated:** 60 requests/hour
- **Authenticated:** 5,000 requests/hour

*OAuth authentication required for full functionality.*

---

## 🧪 Testing

### Running Tests

```bash
# Run all tests
Cmd + U in Xcode

# Or via command line
xcodebuild test -scheme Solanum -destination 'platform=iOS Simulator,name=iPhone 15 Pro'
```

### Test Coverage

- [ ] Timer logic unit tests
- [ ] Session persistence tests
- [ ] GitHub API integration tests
- [ ] UI snapshot tests

*Testing framework will be expanded as features are added.*

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 Charlie (@charlieijk)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction...
```

---

## 👨‍💻 Author

**Charlie** ([@charlieijk](https://github.com/charlieijk))

- Computer Science Student at CCSF
- Passionate about Full Stack Development, Machine Learning, Systems Programming
- Building tools to help developers stay productive

### My Portfolio Projects

- **[BitTorrent](https://github.com/charlieijk/BitTorrent)** - Custom BitTorrent protocol implementation in Rust
- **[ApiGateway](https://github.com/charlieijk/ApiGateway)** - Go-based router implementation
- **[PredictiveStockAnalysis](https://github.com/charlieijk/PredictiveStockAnalysis)** - ML-powered stock prediction
- **Solanum** - This project! 🍅

---

## 🙏 Acknowledgments

- **Francesco Cirillo** - Creator of the Pomodoro Technique
- **Apple** - For SwiftUI and excellent development tools
- **GitHub** - For the comprehensive API
- **The iOS Dev Community** - For inspiration and guidance

---

## 📬 Contact & Support

- **GitHub Issues:** [Report a bug](https://github.com/charlieijk/Solanum/issues)
- **Discussions:** [Ask questions or share ideas](https://github.com/charlieijk/Solanum/discussions)
- **Email:** [Your email here]

---

## 🌟 Star History

If you find Solanum useful, please consider giving it a star! ⭐

[![Star History Chart](https://api.star-history.com/svg?repos=charlieijk/Solanum&type=Date)](https://star-history.com/#charlieijk/Solanum&Date)

---

## 📈 Project Status

**Current Version:** 0.1.0-alpha  
**Development Status:** Active 🟢  
**Last Updated:** November 4, 2025

### Recent Updates

- ✅ Initial project setup
- ✅ Core timer functionality
- ✅ Beautiful gradient UI
- ✅ Session tracking
- 🚧 GitHub integration (in progress)

---

<p align="center">
  <b>Built with ❤️ and lots of ☕ by <a href="https://github.com/charlieijk">@charlieijk</a></b>
</p>

<p align="center">
  <sub>Tomato emoji not included in binary. 🍅</sub>
</p>
