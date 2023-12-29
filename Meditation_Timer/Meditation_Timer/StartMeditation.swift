import SwiftUI
import CoreData

struct StartMeditation: View {
    // State variables to manage meditation timer and selected duration
    @State private var remainingTime: Int = 0
    @State private var isTimerRunning: Bool = false
    @State private var selectedDuration: Int? = nil

    // Timer for updating the remaining time
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            // Display remaining time in minutes and seconds
            Text(String(format: "%02d:%02d", remainingTime / 60, remainingTime % 60))
                .font(.system(size: 24))
                .foregroundColor(.white)
                .padding()

            // Buttons to select meditation duration
            HStack {
                ForEach([5, 10, 15, 20], id: \.self) { duration in
                    Button(action: {
                        selectedDuration = duration
                    }) {
                        Text("\(duration) mins")
                            .foregroundColor(.white)
                            .padding()
                            .background(selectedDuration == duration ? Color.orange : Color.clear)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)

            // Buttons to start and cancel the meditation timer
            HStack {
                Button(action: {
                    if let duration = selectedDuration {
                        startMeditationTimer(duration: duration)
                    }
                }) {
                    Text("Start")
                        .foregroundColor(.white)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.black]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)

                Button(action: {
                    stopMeditationTimer()
                }) {
                    Text("Cancel")
                        .foregroundColor(.white)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.black]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)
            }
        }
        .onReceive(timer) { _ in
            // Update remaining time based on the timer
            if isTimerRunning {
                if remainingTime > 0 {
                    remainingTime -= 1
                } else {
                    isTimerRunning = false
                    handleMeditationCompletion()
                }
            }
        }.background(
            // Background image for the meditation view
            Image("imageName")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
    }

    // Handle actions when meditation session is completed
    private func handleMeditationCompletion() {
        guard let duration = selectedDuration else {
            return
        }

        // Save meditation session to Core Data
        let meditationSession = MeditationSession(context: CoreDataStack.shared.viewContext)
        meditationSession.startTime = Date()
        meditationSession.endTime = Date()
        meditationSession.duration = Int16(duration)

        CoreDataStack.shared.saveContext()
    }

    // Start the meditation timer with the specified duration
    private func startMeditationTimer(duration: Int) {
        selectedDuration = nil
        remainingTime = duration * 60
        isTimerRunning = true
    }

    // Stop the meditation timer
    private func stopMeditationTimer() {
        selectedDuration = nil
        isTimerRunning = false
    }
}
