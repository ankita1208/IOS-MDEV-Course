import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: StartMeditationView()) {
                    CardView(imageName: "meditationImage", title: "Start Meditation")
                        .padding(24)
                }

                NavigationLink(destination: ProgressTrackingView()) {
                    CardView(imageName: "progressImage", title: "View Progress")
                        .padding(24)
                }

                NavigationLink(destination: AudioLibraryView()) {
                    CardView(imageName: "musicImage", title: "Audio Library")
                        .padding(24)
                }
            }
            .navigationBarTitle("Meditation Timer")
            .background(
                Image("imageName")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }
}



struct CardView: View {
    var imageName: String
    var title: String

    var body: some View {
        NavigationLink(destination: destinationForCard()) {
            VStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color.pink)

                Text(title)
                    .font(.headline)
                    .foregroundColor(Color.pink)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color.white)
                .shadow(radius: 4))
        }
    }

    // Function to determine the destination view based on the title
    private func destinationForCard() -> some View {
       
        switch title {
        case "Start Meditation":
            return AnyView(StartMeditation())
        case "View Progress":
            return AnyView(ProgressTrackingModel())
        case "Audio Library":
            return AnyView(AudioView())
        default:
            return AnyView(EmptyView())
        }
    }
}

struct StartMeditationView: View {
    var body: some View {
        Text("Start Meditation Screen")
    }
}

struct ProgressTrackingView: View {
    var body: some View {
        Text("Progress Tracking Screen")
    }
}

struct AudioLibraryView: View {
    var body: some View {
        Text("Audio Library Screen")
    }
}
