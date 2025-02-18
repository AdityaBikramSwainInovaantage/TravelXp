//
//  VideoPlayerController.swift
//  TravelXpMediaPlayer
//
//  Created by Aditya Bikram Swain on 17/02/25.
//
import AVKit
import SwiftUI
import AVKit

struct VideoPlayerController: UIViewControllerRepresentable {
    let player: AVPlayer?
    @Binding var progress: Double
    @Binding var duration: Double
    @Binding var isPlaying: Bool

    // To observe time changes in the AVPlayer
    class Coordinator: NSObject {
        var parent: VideoPlayerController
        private var timeObserver: Any?

        init(parent: VideoPlayerController) {
            self.parent = parent
        }

        func startObserving() {
            guard let player = parent.player else { return }
            
            timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1.0, preferredTimescale: 600), queue: .main) { [weak self] time in
                guard let self = self else { return }
                self.parent.progress = CMTimeGetSeconds(time)
            }
        }

        func stopObserving() {
            if let player = parent.player, let timeObserver = timeObserver {
                player.removeTimeObserver(timeObserver)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false // Hide default controls
        
        // Start observing the time
        context.coordinator.startObserving()
        
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Ensure play/pause state is synced with the view
        if isPlaying, uiViewController.player?.timeControlStatus != .playing {
            uiViewController.player?.play()
        } else if !isPlaying, uiViewController.player?.timeControlStatus != .paused {
            uiViewController.player?.pause()
        }
        
        // Update duration when player is ready
        if let duration = uiViewController.player?.currentItem?.asset.duration {
            self.duration = CMTimeGetSeconds(duration)
        }
    }

    // Cleanup time observer when the view is destroyed
    static func dismantleUIViewController(_ uiViewController: AVPlayerViewController, coordinator: Self.Coordinator) {
        coordinator.stopObserving()
    }
}
