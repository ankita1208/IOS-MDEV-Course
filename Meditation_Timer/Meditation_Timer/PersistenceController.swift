import CoreData

// Struct for managing Core Data persistence
struct PersistenceController {
    // Singleton instance
    static let shared = PersistenceController()

    // NSPersistentContainer for Core Data
    let container: NSPersistentContainer

    // Initialize the persistent container
    init() {
        // Use the "MeditationSession" Core Data model
        container = NSPersistentContainer(name: "MeditationSession")

        // Load persistent stores
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                // Handle errors during persistent store loading
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }

    // Preview instance for adding sample data
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        // Add sample data here if needed
        return result
    }()

    // Initialize the persistent container with an option for in-memory storage
    init(inMemory: Bool = false) {
        // Use the "AudioItem" Core Data model
        container = NSPersistentContainer(name: "AudioItem")

        // Configure for in-memory storage if specified
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        // Load persistent stores
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                // Handle errors during persistent store loading
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
}
