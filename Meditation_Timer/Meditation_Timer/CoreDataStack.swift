//
//  CoreDataStack.swift
//  Meditation_Timer
//
//  Created by ANUJ on 2023-12-02.
//

import CoreData

class CoreDataStack {
    // Singleton instance of the CoreDataStack
    static let shared = CoreDataStack()

    // NSPersistentContainer to manage Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MeditationSession")
        
        // Load persistent stores (SQLite database, by default)
        container.loadPersistentStores { _, error in
            if let error = error {
                // Fatal error if loading persistent stores fails
                fatalError("Unresolved error \(error)")
            }
        }
        
        return container
    }()

    // View context for performing Core Data operations
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // Save changes in the Core Data context
    func saveContext() {
        if viewContext.hasChanges {
            do {
                // Attempt to save changes
                try viewContext.save()
            } catch {
                // Fatal error if saving changes fails
                fatalError("Unresolved error \(error)")
            }
        }
    }
}
