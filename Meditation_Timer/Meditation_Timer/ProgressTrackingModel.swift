import SwiftUI
import CoreData

// Update ProgressEntry to conform to NSManagedObject
class ProgressEntry: NSManagedObject, Identifiable {
    @NSManaged var id: UUID
    @NSManaged var date: Date
    @NSManaged var duration: Double
    // Add other properties as needed

    // Required designated initializer for NSManagedObject
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    // Convenience initializer to create ProgressEntry from a date
    convenience init(date: Date, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "ProgressEntry", in: context)!
        self.init(entity: entity, insertInto: context)
        self.id = UUID()
        self.date = date
        self.duration = duration
        // Initialize other properties as needed
    }
}

struct ProgressTrackingModel: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedFilter = "Last 7 Days"
    @State private var chartData: [ProgressEntry] = []

    var body: some View {
        VStack {
            Text("Progress Tracking")
                .font(.title)
                .foregroundColor(.white)
                .padding(.top, 20)

            Button(action: {
                // Handle back button click
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
                    .padding()
            }
            .padding(.top, -40)
            .padding(.leading, 20)

            Picker("Filter", selection: $selectedFilter) {
                Text("Last 7 Days").tag("Last 7 Days")
                Text("All Sessions").tag("All Sessions")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(20)

            // BarChartView with fetched data
            BarChartView(entries: chartData)
                .frame(height: 300)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                .padding(20)

            Text("Duration:")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, 20)
                .padding(.horizontal, 20)

            Text("Type:")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, 8)
                .padding(.horizontal, 20)

            Spacer()
        }
        .background(
            Image("imageName")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
        .onAppear {
            updateChartData(selectedFilter: selectedFilter)
        }
    }

    private func updateChartData(selectedFilter: String) {
        switch selectedFilter {
        case "Last 7 Days":
            fetchDataForLastNDays(7)
        case "All Sessions":
            fetchAllSessionData()
        default:
            break
        }
    }

    private func fetchDataForLastNDays(_ numberOfDays: Int) {
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -numberOfDays, to: endDate)

        // Fetch data from CoreData based on the date range
        chartData = fetchEntriesInDateRange(startDate: startDate, endDate: endDate)
    }

    private func fetchAllSessionData() {
        // Fetch all session data from CoreData
        chartData = fetchAllEntries()
    }

    private func fetchEntriesInDateRange(startDate: Date?, endDate: Date?) -> [ProgressEntry] {
        // Implement the logic to fetch ProgressEntry entities from CoreData
        // where the date is within the specified range
        // Update the return type based on your actual data model

        // Example:
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ProgressEntry")
        if let startDate = startDate, let endDate = endDate {
            fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
        }

        do {
            if let result = try CoreDataStack.shared.viewContext.fetch(fetchRequest) as? [ProgressEntry] {
                return result
            } else {
                return []
            }
        } catch {
            print("Error fetching entries: \(error)")
            return []
        }
    }

    private func fetchAllEntries() -> [ProgressEntry] {
        // Implement the logic to fetch all ProgressEntry entities from CoreData
        // Update the return type based on your actual data model

        // Example:
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ProgressEntry")

        do {
            if let result = try CoreDataStack.shared.viewContext.fetch(fetchRequest) as? [ProgressEntry] {
                return result
            } else {
                return []
            }
        } catch {
            print("Error fetching entries: \(error)")
            return []
        }
    }
}

struct ProgressTrackingModel_Previews: PreviewProvider {
    static var previews: some View {
        ProgressTrackingModel()
    }
}
