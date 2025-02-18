# TravelXpMediaPlayer

A multimedia player application designed for seamless playback with intuitive controls and device responsiveness, built using **SwiftUI**.

## Features Implemented

- **Custom Navigation Bar**: A sleek navigation bar with a close button and volume slider.
- **Playback Controls**: Buttons for Play, Pause, Back 10 seconds, and Forward 10 seconds.
- **Continue Watching Section**: A section that remembers your progress and allows you to continue watching from where you left off.
- **Responsive Design**: Optimized for different screen sizes, including phones and tablets.

### **Technologies Used**
- **Swift**: The main programming language used for the development of this iOS application.
- **SwiftUI**: The framework used for building the app's user interface, providing a declarative and modern way to design the UI components.
- **AVKit**: A framework used to handle media playback, including playing video files and controlling playback.

### **Key Frameworks**
- **AVPlayer**: Used for controlling video playback, handling functions like play, pause, and seek.
- **SwiftUI**: Used for the UI layout and handling user interactions through declarative syntax.
  
### **Project Structure**
- **Model-View-ViewModel (MVVM) Pattern**: The application follows the MVVM design pattern to separate the UI from business logic. The ViewModel manages the data and the logic for the view, making it easy to maintain and scale.
  
  - `MediaPlayerViewModel.swift`: Manages the media player functionality, including playback control, video progress tracking, and volume adjustments.

- **Assets**: Includes video files, image assets, and custom icons used for the player interface.

## Setup Instructions

1. **Repository**:
    ```bash
    https://github.com/AdityaBikramSwainInovaantage/TravelXp/tree/master
    ```
2. **Install dependencies**:
    This project does not require any external dependencies, so no need for **CocoaPods** or **Swift Package Manager**.

3. **Open the project**:
    Open `TravelXpMediaPlayer.xcworkspace` in **Xcode**.

4. **Run the app**:
    Select your target device or simulator, then press **Cmd + R** to run the app.

## Features Description

- **Media Player Screen**: Displays video content with playback controls, including volume adjustments, pause/play functionality, and 10-second skip buttons.
- **Continue Watching**: The app tracks your current position and lets you resume from where you left off.
- **Custom UI Elements**: The navigation bar and controls are custom-designed for an enhanced user experience.
- **Responsive**: Designed for devices of all sizes, from iPhone SE to iPad Pro.



- **Portrait Mode UI Issue**: Currently, there are some production iss![simulator_screenshot_96E37A6E-7883-4AD9-A580-3C09325B6C42](
ues related to the **portrait mode UI**. Due to time constraints, I was unable to complete the necessary adjustments. The UI might not be fully optimized for portrait orientation, and some components may appear misaligned or unresponsive in this mode.  
  **Users are encouraged to test the app in landscape mode for the most optimal user experience at this stage.**
- **Upcoming Improvements**: The portrait mode UI issue will be addressed in future updates. Thank you for your understanding and patience!
- **App Overview**: Show the main screen of the media player app.
- **Playback Controls**: Demonstrate how the user can control 
playback (Play/Pause, 10-second back/forward).
- **Continue Watching**: Show how the app saves the user’s progress and allows resuming from where they left off.
- **Responsiveness**: Showcase how the UI adapts to different screen sizes (iPhone vs. iPad).




-  ## Notes**
Apologies, due to ongoing production issues at my current company, I couldn't dedicate enough time to complete all aspects of the project. As a result, some features, particularly the portrait mode UI, may not work as expected.


## Screenshots
![simulator_screenshot_94F4046F-16E1-4127-8061-B45BCFF5A78E](https://github.com/user-attachments/assets/a8a48adf-1bfd-4080-8f56-e1f434196b20)
![simulator_screenshot_67833A7E-66E9-4107-BA73-66FEBC35F391](https://github.com/user-attachments/assets/a4a93407-00b8-4d88-8a4d-1616175c2c60)
