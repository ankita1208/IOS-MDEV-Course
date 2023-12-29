//
//  ContentView.swift
//  Ankita_Sharma_MidTerm
//
//  Created by ankita sharma on 04/10/23.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var notificationPermissionGranted = false
    
    var body: some View {
        VStack {
            Text("Ankita Sharma")
                .font(.title)
                .padding()

            Text("200553757")
                .font(.subheadline)
                .padding()

            Spacer()

            Button(action: {
                scheduleLocalNotification()
            }) {
                Text("Hungry?")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
        .onAppear {
            requestNotificationPermissions()
        }
    }

    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted {
                    print("Notification permissions granted.")
                    self.notificationPermissionGranted = true
                } else {
                    print("Notification permissions denied.")
                }
            }
    }

    func scheduleLocalNotification() {
        guard notificationPermissionGranted else {
            print("Notification permissions not granted.")
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "Hungry?"
        content.body = "We are out of food!"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled successfully!")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
