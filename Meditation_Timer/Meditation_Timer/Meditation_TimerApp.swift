//
//  Meditation_TimerApp.swift
//  Meditation_Timer
//
//  Created by ANUJ on 2023-12-04.
//

import SwiftUI

@main
struct Meditation_TimerApp: App {
    // Create an instance of the PersistenceController for managing Core Data
    let persistenceController = PersistenceController.shared
    
    // Create an instance of the NotificationManager for handling notifications
    let notificationManager = NotificationManager()
    
    var body: some Scene {
        WindowGroup {
            // Main content view (initial screen of the app)
            ContentView().environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    // Set up notifications when the app appears
                    notificationManager.setupNotifications()
                }
        }
    }
}
