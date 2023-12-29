import SwiftUI
import AVKit

// SwiftUI wrapper for AVPlayerViewController
struct AudioPlayer: UIViewControllerRepresentable {
    var url: URL  // URL of the audio to play
    @Binding var isPlaying: Bool  // Binding to control playback state

    // Create the AVPlayerViewController
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        let player = AVPlayer(url: url)
        controller.player = player
        return controller
    }

    // Update the AVPlayerViewController based on the isPlaying state
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        if isPlaying {
            uiViewController.player?.play()
        } else {
            uiViewController.player?.pause()
        }
    }
}
