//
//  AudioManager.swift
//  Melofy_music_api_app
//
//  Created by Apple on 18/05/25.
//

import Foundation
import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    private var player: AVPlayer?
    private var currentUrl: URL?

    var isPlaying: Bool {
        player?.timeControlStatus == .playing
    }

    func play(url: URL) {
        if currentUrl != url {
            player?.pause()
            player = AVPlayer(url: url)
            currentUrl = url
            addObserver()
        }
        player?.play()
        NotificationCenter.default.post(name: .AudioManagerDidStartPlaying, object: nil)
    }

    func pause() {
        player?.pause()
        NotificationCenter.default.post(name: .AudioManagerDidPause, object: nil)
    }

    func stop() {
        player?.pause()
        player = nil
        currentUrl = nil
        NotificationCenter.default.post(name: .AudioManagerDidStop, object: nil)
    }

    private func addObserver() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
    }

    @objc private func playerDidFinishPlaying() {
        NotificationCenter.default.post(name: .AudioManagerDidFinishPlaying, object: nil)
    }

    func isPlaying(url: URL) -> Bool {
        return currentUrl == url && isPlaying
    }
}

extension Notification.Name {
    static let AudioManagerDidStartPlaying = Notification.Name("AudioManagerDidStartPlaying")
    static let AudioManagerDidPause = Notification.Name("AudioManagerDidPause")
    static let AudioManagerDidStop = Notification.Name("AudioManagerDidStop")
    static let AudioManagerDidFinishPlaying = Notification.Name("AudioManagerDidFinishPlaying")
}
