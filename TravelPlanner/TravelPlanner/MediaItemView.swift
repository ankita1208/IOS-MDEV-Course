//
//  TravelPlanner
//
//  Created by ankita sharma on 03/12/23.
//
import SwiftUI

struct MediaItemView: View {
    @ObservedObject var mediaViewModel: MediaViewModel
    var mediaEntity: MediaEntity

    var body: some View {
        VStack {
            if let imageData = mediaViewModel.getImageData(for: mediaEntity),
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                Text("Image Loaded") // Add this line for debugging
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .foregroundColor(.gray)
                Text("No Image Data") // Add this line for debugging
            }

            Text(mediaEntity.title ?? "Unknown Title")
                .padding()
                .foregroundColor(.black)
        }
        .padding()
        .onAppear {
            print("MediaItemView Appeared for \(mediaEntity.title ?? "Unknown Title")")
        }
    }
}
