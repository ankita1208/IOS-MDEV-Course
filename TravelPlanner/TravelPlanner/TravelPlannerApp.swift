//
//  TravelPlanner
//
//  Created by ankita sharma on 03/12/23.
//
import SwiftUI
    

@main
struct TravelPlannerApp: App {
    // Inject the managed object contexts into the environment
    let persistenceController = PersistenceController.shared
    @StateObject private var mediaViewModel = MediaViewModel()
    @StateObject private var mediaViewModelWrapper = MediaViewModel.Wrapper()



    var body: some Scene {
        WindowGroup {
            // Pass the managed object contexts to the ContentView
            ContentView()
                .environment(\.managedObjectContext, persistenceController.tripModelContainer.viewContext)
                .environment(\.mediaEntityContext, persistenceController.mediaEntityContainer.viewContext)
                .environmentObject(mediaViewModel)
        }
    }
}

