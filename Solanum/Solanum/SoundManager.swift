//
//  SoundManager.swift
//  Solanum
//
//  Manages audio feedback for timer events
//

import Foundation
import AVFoundation
internal import Combine

@MainActor
class SoundManager: ObservableObject {
    static let shared = SoundManager()

    @Published var isSoundEnabled = true
    @Published var soundVolume: Float = 0.7

    private var audioPlayer: AVAudioPlayer?

    private init() {
        loadSettings()
        setupAudioSession()
    }

    // MARK: - Audio Session Setup
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }

    // MARK: - Sound Playback
    func playSessionComplete() {
        guard isSoundEnabled else { return }
        playSystemSound(1057) // Bell sound
    }

    func playTick() {
        guard isSoundEnabled else { return }
        playSystemSound(1103) // Tick sound
    }

    func playSessionStart() {
        guard isSoundEnabled else { return }
        playSystemSound(1115) // Gentle chime
    }

    private func playSystemSound(_ soundID: SystemSoundID) {
        AudioServicesPlaySystemSound(soundID)
    }

    // MARK: - Settings Persistence
    func saveSettings() {
        UserDefaults.standard.set(isSoundEnabled, forKey: "soundEnabled")
        UserDefaults.standard.set(soundVolume, forKey: "soundVolume")
    }

    private func loadSettings() {
        isSoundEnabled = UserDefaults.standard.object(forKey: "soundEnabled") as? Bool ?? true
        soundVolume = UserDefaults.standard.object(forKey: "soundVolume") as? Float ?? 0.7
    }
}
