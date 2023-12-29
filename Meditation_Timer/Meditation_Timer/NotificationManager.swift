import Foundation
import UIKit
import UserNotifications

class NotificationManager {

    // Function to set up daily meditation reminders
    func setupNotifications() {
        createNotificationChannel()

        // Set up the UNNotificationRequest for daily notifications
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Meditation Reminder"
        notificationContent.body = "It's time for your meditation session!"
        notificationContent.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyMeditation", content: notificationContent, trigger: trigger)

        // Schedule the notification request
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }

    // Function to create a notification channel for iOS 10 and later
    private func createNotificationChannel() {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()

            // Request authorization to display notifications
            center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                if granted {
                    // Configure notification content
                    let content = UNMutableNotificationContent()
                    content.title = "Meditation Reminder"
                    content.body = "It's time for your meditation session!"
                    content.sound = UNNotificationSound.default

                    // Set up trigger for immediate notification
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)

                    // Create and add the notification request
                    let request = UNNotificationRequest(identifier: "MeditationNotification", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request) { (error) in
                        if let error = error {
                            print("Error adding notification request: \(error.localizedDescription)")
                        }
                    }
                } else if let error = error {
                    print("Error requesting notification authorization: \(error.localizedDescription)")
                }
            }
        }
    }
}

