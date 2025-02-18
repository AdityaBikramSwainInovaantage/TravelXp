//
//  TravelXpMediaPlayerApp.swift
//  TravelXpMediaPlayer
//
//  Created by Aditya Bikram Swain on 17/02/25.
//

import SwiftUI

@main
struct TravelXpMediaPlayerApp: App {
    var body: some Scene {
        WindowGroup {
            let sampleVideo = VideoModel(
                title: "Chhaava",
                description: "An upcoming historical epic film...",
                thumbnail: "Chhaava",
                filename: "Chhaava"
            )
            let viewModel = MediaPlayerViewModel(video: sampleVideo)
            MediaPlayer(viewModel: viewModel)
        }
    }
}
