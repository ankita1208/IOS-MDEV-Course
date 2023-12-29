//
//  TravelPlanner
//
//  Created by ankita sharma on 03/12/23.
//
import SwiftUI

struct AccessGalleryView: View {
    @StateObject private var mediaViewModel = MediaViewModel()
    @State private var selectedMediaEntity: MediaEntity?

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(mediaViewModel.mediaList) { mediaEntity in
                        NavigationLink(destination: EditMediaDetailsView(mediaViewModel: mediaViewModel, mediaEntity: mediaEntity)) {
                            MediaItemView(mediaViewModel: mediaViewModel, mediaEntity: mediaEntity)
                        }
                    }
                }
                .listStyle(PlainListStyle())

                // Add Media button
                NavigationLink(destination: AddMediaView()) {
                    Text("Add Media")
                }
                .padding()
            }
            .onAppear {
                mediaViewModel.fetchMediaItems()
                print("Media List Count: \(mediaViewModel.mediaList.count)")
            }
        }
    }
}
