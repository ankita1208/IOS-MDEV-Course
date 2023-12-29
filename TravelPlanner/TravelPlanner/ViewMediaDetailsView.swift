//
//
//  ViewMediaDetailsView.swift
//  TravelPlanner
//
//  Created by ankita sharma on 03/12/23.
//

import SwiftUI

struct ViewMediaDetailsView: View {
    var mediaEntity: MediaEntity

    var body: some View {
        ScrollView {
            VStack {
                // Image View
                RemoteImage(url: mediaEntity.mediaUrl ?? "")
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()

                // Media Details
                VStack(alignment: .leading, spacing: 8) {
                    Text("Viewing details for \(mediaEntity.title ?? "Unknown Title")") // Safely unwrap optional
                        .font(.title)
                        .fontWeight(.bold)

                    Text(mediaEntity.description ?? "")  // Safely unwrap optional
                        .font(.body)
                }
                .padding(16)
            }
            .onAppear {
                // You can add any logic you want to perform when the view appears
                print("View appeared")
            }
        }
        .navigationTitle("View Media")
    }
}
