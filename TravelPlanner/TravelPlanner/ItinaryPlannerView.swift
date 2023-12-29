//
//  ContentView.swift
//  TravelPlanner
//
//  Created by ankita sharma on 03/12/23.
//



import SwiftUI
import CoreData

struct ItineraryPlannerView: View {
    @State private var fromLocation = ""
    @State private var toLocation = ""
    @State private var departureDate = ""
    @State private var returnDate = ""
    @State private var adults = ""
    @State private var children = ""
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .cornerRadius(8)
                        .clipped()
                    
                    LabelTextField(label: "From", placeholder: "Enter location", text: $fromLocation)
                    LabelTextField(label: "To", placeholder: "Enter location", text: $toLocation)
                    
                    Divider()
                    
                    LabelTextField(label: "Departure", placeholder: "Select date", text: $departureDate)
                        .keyboardType(.numbersAndPunctuation)
                    
                    LabelTextField(label: "Return", placeholder: "Select date", text: $returnDate)
                        .keyboardType(.numbersAndPunctuation)
                    
                    Divider()
                    
                    LabelTextField(label: "Adults", placeholder: "Enter number", text: $adults)
                        .keyboardType(.numberPad)
                    
                    LabelTextField(label: "Children", placeholder: "Enter number", text: $children)
                        .keyboardType(.numberPad)
                    
                    Button(action: {
                        // Handle edit itinerary button tap
                        saveTrip()
                    }) {
                        Text("Book This Trip")
                            .padding()
                            .background(Color(hex: "5d9d79"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.top, 16)
                    }
                }
                .padding()
            }
        }
    }

    private func saveTrip() {
        // Save the trip to Core Data
        withAnimation {
            let newTrip = Trip(context: viewContext)
            newTrip.fromLocation = fromLocation
            newTrip.toLocation = toLocation
            
            // Convert departureDate and returnDate strings to Date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            
            if let departureDateValue = dateFormatter.date(from: departureDate) {
                newTrip.departureDate = departureDateValue
            }
            
            if let returnDateValue = dateFormatter.date(from: returnDate) {
                newTrip.returnDate = returnDateValue
            }
            
            newTrip.adults = Int16(adults) ?? 0
            newTrip.children = Int16(children) ?? 0
            
            do {
                try viewContext.save()
                // Dismiss the view after saving the trip
                presentationMode.wrappedValue.dismiss()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    struct LabelTextField: View {
        var label: String
        var placeholder: String
        @Binding var text: String
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(label)
                    .font(.headline)
                    .foregroundColor(.gray)
                
                TextField(placeholder, text: $text)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.gray, lineWidth: 1))
            }
        }
    }
}

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        self.init(
            .sRGB,
            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgb & 0x0000FF) / 255.0,
            opacity: 1.0
        )
    }
}
