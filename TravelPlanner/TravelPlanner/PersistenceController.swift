//
//  TravelPlanner
//
//  Created by ankita sharma on 03/12/23.
//
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let tripModelContainer: NSPersistentContainer
    let mediaEntityContainer: NSPersistentContainer

    init() {
        tripModelContainer = NSPersistentContainer(name: "TripModel")
        tripModelContainer.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        mediaEntityContainer = NSPersistentContainer(name: "MediaEntityModel")
        mediaEntityContainer.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    // Add this method to save the context
    func save() {
        let tripModelContext = tripModelContainer.viewContext
        let mediaEntityContext = mediaEntityContainer.viewContext

        if tripModelContext.hasChanges {
            do {
                try tripModelContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }

        if mediaEntityContext.hasChanges {
            do {
                try mediaEntityContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
