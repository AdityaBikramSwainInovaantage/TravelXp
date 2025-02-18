import SwiftUI
import AVFoundation

struct MediaPlayer: View {
    @StateObject private var viewModel: MediaPlayerViewModel
    @State private var position: CGFloat = 0
    @State private var lastDragValue: CGFloat = 0
    @State private var showViewController: Bool = true
    @State private var isPlaying: Bool = true
    @State private var currentTime: Double = 0.0
    @State private var duration: Double = 1.0  // Add the duration property
    @State private var sliderViewPosition: CGFloat = 0
    @Environment(\.presentationMode) var presentationMode // For back navigation
    @State private var progressTimer: Timer?
    
    init(viewModel: MediaPlayerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometryProxy in
                let dynamicHeight = geometryProxy.size.height * 0.4 // Adjustable height for the rectangle
                let restHeight = (geometryProxy.size.height - dynamicHeight) / 2 // Remaining space for top limit
                let remaingHeigtForSlider = geometryProxy.size.height - dynamicHeight
                Color.black.ignoresSafeArea()
                ZStack {
                    VStack {
                        VStack {
                            VideoPlayerController(
                                player: viewModel.player,
                                progress: $viewModel.progress,   // Correct way to pass a binding
                                duration: $viewModel.duration,
                                isPlaying: $viewModel.isPlaying
                            )
                            .overlay {
                                if showViewController {
                                    playBackController()
                                }
                            }
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    showViewController.toggle()
                                }
                            }
                            .frame(width: geometryProxy.size.width, height: dynamicHeight)
                            .position(x: geometryProxy.frame(in: .local).midX,
                                      y: geometryProxy.frame(in: .local).midY + position)
                        }
                        VStack {
                            showViewController ? sliderWithInfor()
                                .position(x: geometryProxy.frame(in: .local).midX,
                                          y: geometryProxy.frame(in: .local).midY + sliderViewPosition - 70) : nil
                            
                        }
                    }
                    
                    VStack {
                        showViewController ? customNavigationBar(volume: $viewModel.volume, onClose: { presentationMode.wrappedValue.dismiss() }) : nil
                        Spacer()
                    }
                    .padding(.top) // Adjust for safe area
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let newPosition = lastDragValue + value.translation.height
                            // Restrict movement between -restHeight and 0, keeping it within bounds
                            if newPosition >= -restHeight && newPosition <= 0 {
                                position = newPosition
                                sliderViewPosition = newPosition
                            }
                        }
                        .onEnded { value in
                            // Spring animation without dampingFraction
                            withAnimation(.spring()) {
                                if value.translation.height < -50 { // Dragged upwards enough
                                    position = -restHeight  // Align with top limit
                                    sliderViewPosition = -remaingHeigtForSlider + 100
                                } else {
                                    position = 0  // Return to original position
                                    sliderViewPosition = 0
                                }
                            }
                            lastDragValue = position
                        }
                )
            }
            .navigationBarHidden(true) // Hide default nav bar
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                     viewModel.start()
                }
            }
        }
    }
    
    @ViewBuilder
    func playBackController() -> some View {
        
        HStack {
            // Back 10 Seconds Button
            Button(action: {
                let currentTime = viewModel.player.currentTime().seconds
                if currentTime >= 10 {
                    let newTime = currentTime - 10
                    let time = CMTime(seconds: newTime, preferredTimescale: 1)
                    viewModel.player.seek(to: time)  // Seek back 10 seconds
                } else {
                    // If current time is less than 10 seconds, seek to the beginning
                    let time = CMTime(seconds: 0, preferredTimescale: 1)
                    viewModel.player.seek(to: time)
                }
                
            }) {
                Image(systemName: "gobackward.10") // Icon for back button
                    .font(.system(size: 30))
                    .foregroundStyle(.white)
                    .padding()
            }
            
            // Play/Pause Button
            Button(action: {
                viewModel.isPlaying.toggle() // Toggle play/pause state
                if viewModel.isPlaying {
                    viewModel.player.play()  // Play the video
                } else {
                    viewModel.player.pause() // Pause the video
                }
            }) {
                Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill") // Play or Pause icon
                    .font(.system(size: 40))
                    .foregroundStyle(.white)
                    .padding()
            }
            
            // Forward 10 Seconds Button
            Button(action: {
                let currentTime = viewModel.player.currentTime().seconds
                let newTime = currentTime + 10
                let time = CMTime(seconds: newTime, preferredTimescale: 1)
                viewModel.player.seek(to: time)  // Seek forward 10 seconds
            }) {
                Image(systemName: "goforward.10") // Icon for forward button
                    .font(.system(size: 30))
                    .foregroundStyle(.white)
                    .padding()
            }
        }
        
    }
    
    
    
    @ViewBuilder
    func sliderWithInfor() -> some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(viewModel.title)
                    .foregroundColor(.white)
                    .font(.title)
                
                let validDuration = duration > 0 ? duration : 1.0
                 // Slider for seeking
                 Slider(value: $currentTime, in: 0...validDuration, onEditingChanged: { isEditing in
                     if !isEditing {
                         print("Seeking to \(currentTime) seconds")
                         // Perform seek operation after editing ends
                         let time = CMTime(seconds: currentTime, preferredTimescale: 1)
                         viewModel.player.seek(to: time)
                     }
                 })
                .accentColor(.white) // Custom accent color for the slider thumb
                .frame(height: 8)  // Custom height for the slider track
                .background(Color.gray.opacity(0.5)) // Gradient background
                .cornerRadius(4) // Rounded corners for the slider track
                .overlay(
                    Capsule()
                        .stroke(Color.white, lineWidth: 2) // White border around the slider track
                )
                
                // Current time and duration text
                HStack {
                    Text(formatTime(currentTime))
                        .foregroundColor(.white)
                    Spacer()
                    Text(formatTime(duration))
                        .foregroundColor(.white)
                }
            }
            
            // Other buttons
            HStack(spacing: 12) {
                CustomButton(title: "Info")
                CustomButton(title: "InSight")
                CustomButton(title: "Continue Watching")
            }
        }
        .transitionMoveDown(showNavigation: showViewController)
        .padding()
        .onAppear {
            observePlayer()
        }
        .onDisappear {
            progressTimer?.invalidate()
        }
    }

    // Format time into MM:SS format
    func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func observePlayer() {
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            let currentPlayerTime = viewModel.player.currentTime()
            self.currentTime = CMTimeGetSeconds(currentPlayerTime)
            
            // Update duration from the player's currentItem
            if let currentItem = viewModel.player.currentItem {
                self.duration = CMTimeGetSeconds(currentItem.duration)
            }
        }
    }

    

    @ViewBuilder
    func customNavigationBar(volume: Binding<Double>, onClose: @escaping () -> Void) -> some View {
        HStack {
            // Close Button
            Button(action: onClose) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            // Volume Control (Speaker Icon and Slider)
            HStack {
                Slider(value: volume, in: 0...1, onEditingChanged: { _ in
                    viewModel.updateVolume(to: volume.wrappedValue)
                })
                .frame(width: 100)
                Image(systemName: "speaker.wave.3.fill")
                    .foregroundColor(.white)
            }
        }
        .padding([.leading, .trailing])
        .background(Color.black.opacity(0.7))
        .transitionModifier(showNavigation: showViewController)
    }


}

#Preview {
    let sampleVideo = VideoModel(
        title: "Chhaava",
        description: "An upcoming historical epic film...",
        thumbnail: "Chhaava",
        filename: "Chhaava"
    )
    let viewModel = MediaPlayerViewModel(video: sampleVideo)
    MediaPlayer(viewModel: viewModel)
}
