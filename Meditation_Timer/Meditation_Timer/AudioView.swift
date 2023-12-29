import SwiftUI
import AVKit

struct AudioView: View {
    // State variable to manage selected audio items
    @State private var selectedAudios: Set<AudioModel> = []

    // Sample audio data
    let audioModel = [
        AudioModel(title: "Guided Meditation 1", duration: "21:28", imageUrl: "video_player", audioUrl: "https://self-compassion.org/wp-content/uploads/meditations/affectionatebreathing.mp3"),
        AudioModel(title: "Guided Meditation 2", duration: "23:55", imageUrl: "video_player", audioUrl: "https://self-compassion.org/wp-content/uploads/meditations/bodyscan.MP3"),
        AudioModel(title: "Background Sound 1", duration: "23:53", imageUrl: "video_player", audioUrl: "https://self-compassion.org/wp-content/uploads/meditations/LKM.MP3"),
        AudioModel(title: "Background Sound 2", duration: "20:10", imageUrl: "video_player", audioUrl: "https://self-compassion.org/wp-content/uploads/meditations/LKM.self-compassion.MP3"),
        AudioModel(title: "Meditation Resource 1", duration: "20:20", imageUrl: "video_player", audioUrl: "https://self-compassion.org/wp-content/uploads/meditations/noting.practice.MP3"),
        AudioModel(title: "Meditation Resource 2", duration: "16:01", imageUrl: "video_player", audioUrl: "https://self-compassion.org/wptest/wp-content/uploads/soften,soothe,allow.MP3")
    ]

    var body: some View {
        NavigationView {
            // List of audio items with selection capability
            List(audioModel, id: \.self) { audioItem in
                AudioListItemView(audioItem: audioItem, isSelected: isSelected(audioItem))
                    .onTapGesture {
                        toggleSelection(audioItem)
                    }
            }
            .navigationBarTitle("Audio List")
            .navigationBarItems(trailing:
                NavigationLink(destination: AudioPlayerListView(selectedAudios: selectedAudios)) {
                    Text("Play Selected")
                }
                .disabled(selectedAudios.isEmpty)
            )
        }
    }

    // Check if an audio item is selected
    func isSelected(_ audioItem: AudioModel) -> Bool {
        selectedAudios.contains(audioItem)
    }

    // Toggle the selection of an audio item
    func toggleSelection(_ audioItem: AudioModel) {
        if isSelected(audioItem) {
            selectedAudios.remove(audioItem)
        } else {
            selectedAudios.insert(audioItem)
        }
    }
}

struct AudioListItemView: View {
    var audioItem: AudioModel
    var isSelected: Bool

    var body: some View {
        // Display each audio item in a row with a checkmark for selection
        HStack {
            Text(audioItem.title)
            Spacer()
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isSelected ? .blue : .gray)
        }
    }
}

struct AudioPlayerListView: View {
    let selectedAudios: Set<AudioModel>

    var body: some View {
        // List of selected audio items to play
        List(Array(selectedAudios), id: \.self) { audioItem in
            NavigationLink(destination: AudioPlayerView(audioItem: audioItem)) {
                Text(audioItem.title)
            }
        }
        .navigationBarTitle("Selected Audios")
    }
}

struct AudioPlayerView: View {
    @State private var player: AVPlayer?
    @State private var isPlaying: Bool = false

    var audioItem: AudioModel

    var body: some View {
        // Display audio player controls
        VStack {
            Text("Now Playing: \(audioItem.title)")
                .font(.headline)
                .padding()

            if let audioURL = URL(string: audioItem.audioUrl) {
                // Use an audio player with play and download options
                AudioPlayer(url: audioURL, isPlaying: $isPlaying)

                HStack(spacing: 20) {
                    Button(action: {
                        isPlaying.toggle()
                    }) {
                        Image(systemName: isPlaying ? "pause.circle" : "play.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                    }

                    Button(action: {
                        // Implement download functionality
                        downloadAudio(url: audioURL)
                    }) {
                        Image(systemName: "arrow.down.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundColor(.green)
                    }
                }
                .padding(.top, 20)
            } else {
                Text("Invalid audio URL")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
    }

    // Download audio functionality
    private func downloadAudio(url: URL) {
        let task = URLSession.shared.downloadTask(with: url) { (tempLocalUrl, response, error) in
            guard let tempLocalUrl = tempLocalUrl, error == nil else { return }
            do {
                // Move the downloaded file to a permanent location
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let destinationUrl = documentsDirectory.appendingPathComponent(url.lastPathComponent)
                try FileManager.default.moveItem(at: tempLocalUrl, to: destinationUrl)
                print("File moved to \(destinationUrl)")

                // Now you can use destinationUrl for playing the downloaded audio
            } catch {
                print("Error saving audio file: \(error)")
            }
        }
        task.resume()
    }
}

// Model representing an audio item
struct AudioModel: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var duration: String
    var imageUrl: String
    var audioUrl: String
}

// Preview for the ContentView
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AudioView()
    }
}
