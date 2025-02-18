//
//  MediaPlayerViewModel.swift
//  TravelXpMediaPlayer
//
//  Created by Aditya Bikram Swain on 17/02/25.
//

import Foundation
import AVFoundation
import SwiftUI

class MediaPlayerViewModel: ObservableObject {
    @Published var player: AVPlayer
    @Published var isPlaying = false
    @Published var progress: Double = 0.0
    @Published var duration: Double = 1.0
    @Published var showThumbnail = true
    @Published var title: String
    @Published var description: String
    @Published var volume: Double = 0.5

    private var timeObserver: Any?

    init(video: VideoModel) {
        self.title = video.title
        self.description = video.description
        // Safely unwrap the URL for the video file
        if let url = Bundle.main.url(forResource: video.filename, withExtension: "mp4") {
            self.player = AVPlayer(url: url)
            self.setupTimeObserver()
        } else {
            self.player = AVPlayer() // Fallback in case the URL is not found
            print("Video file not found in assets: \(video.filename).mp4")
        }
    }

    // Setup periodic time observer
    private func setupTimeObserver() {
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { [weak self] time in
            self?.progress = time.seconds
            if let currentItem = self?.player.currentItem {
                self?.duration = currentItem.duration.seconds
            }
        }
    }

    // Start video playback
    func start() {
        player.play()
        isPlaying = true
    }

    // Pause video playback
    func pause() {
        player.pause()
        isPlaying = false
    }

    // Seek video to specific time
    func seekToTime(_ time: Double) {
        let time = CMTime(seconds: time, preferredTimescale: 1)
        player.seek(to: time)
    }
    func updateVolume(to volume: Double) {
        self.volume = volume
        player.volume = Float(volume)
    }
    // Remove time observer when the view model is deinitialized
    deinit {
        if let timeObserver = timeObserver {
            player.removeTimeObserver(timeObserver)
        }
    }
}
