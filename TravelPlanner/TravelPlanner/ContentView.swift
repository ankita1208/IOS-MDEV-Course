//
//  ContentView.swift
//  TravelPlanner
//
//  Created by ankita sharma on 03/12/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Trip.toLocation, ascending: true)]) var trips: FetchedResults<Trip>
    let sampleMediaEntity = MediaEntity()
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Hi there")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "5d9d79"))
                        .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))

                    Text("Plan your next trip")
                        .font(.title2)
                        .foregroundColor(Color.black)
                        .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 15))

                    SearchBar()

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(trips) { trip in
                            TripCard(trip: trip)
                        }
                    }
                    .padding(15)
                

                    NavigationLink(destination: ItineraryPlannerView()) {
                        Text("Plan a Trip")
                    }
                    .buttonStyle(MainButtonStyle(buttonColor: Color(hex: "5d9d79"), isRectangle: true))

                    NavigationLink(destination: AccessGalleryView()) {
                        Text("Access Gallery")
                    }
                    .buttonStyle(MainButtonStyle(buttonColor: Color(hex: "5d9d79"), isRectangle: true))

                }
            }
            .navigationTitle("Travel Planner")
        }
    }
}

struct TripCard: View {
    var trip: Trip

    var body: some View {
        VStack {
            Image(systemName: "photo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 120)
                .clipped()

            Text(trip.toLocation ?? "")
                .font(.caption)
                .padding(8)
        }
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}

struct SearchBar: View {
    @State private var searchText = ""

    var body: some View {
        TextField("Search your destination", text: $searchText)
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color("view_color"), lineWidth: 2))
            .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
    }
}

struct MainButtonStyle: ButtonStyle {
    var buttonColor: Color
    var isRectangle: Bool

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.white)
            .background(isRectangle ? buttonColor : configuration.isPressed ? Color.gray : buttonColor)
            .cornerRadius(isRectangle ? 8 : 0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
