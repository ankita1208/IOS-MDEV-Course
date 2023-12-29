//
//  TravelPlanner
//
//  Created by ankita sharma on 03/12/23.
//
import SwiftUI
import SDWebImageSwiftUI
import UIKit
import Combine

struct EditMediaDetailsView: View {
    // Use Image instead of UIImage
    @State private var selectedImage: UIImage?
    @State private var editMediaTitle = ""
    @State private var editMediaDescription = ""
    @State private var isImagePickerPresented = false

    // Add presentationMode as a parameter
    @Environment(\.presentationMode) var presentationMode

    // Observe changes in the mediaEntity
    @ObservedObject var mediaViewModel: MediaViewModel
    var mediaEntity: MediaEntity

    // Combine publisher for observing changes in selectedImage
    private var selectedImagePublisher: AnyPublisher<Void, Never> {
        Just(selectedImage)
            .map { _ in () }
            .eraseToAnyPublisher()
    }

    init(mediaViewModel: MediaViewModel, mediaEntity: MediaEntity) {
        self.mediaViewModel = mediaViewModel
        self.mediaEntity = mediaEntity
    }

    var body: some View {
        VStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(Rectangle())
                    .onReceive(selectedImagePublisher) { _ in }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .foregroundColor(.gray)
            }

            Button(action: {
                // Show the image picker
                isImagePickerPresented.toggle()
            }) {
                HStack {
                    Image(systemName: "photo.on.rectangle.angled")
                    Text("Upload File")
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
            }
            .padding()
            .sheet(isPresented: $isImagePickerPresented, onDismiss: loadImage) {
                ImagePicker(selectedImage: $selectedImage)
            }

            TextField("Media Title", text: $editMediaTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onAppear {
                    // Set initial values when the view appears
                    editMediaTitle = mediaEntity.title ?? ""
                    editMediaDescription = mediaEntity.mediaDescription ?? ""
                }

            TextEditor(text: $editMediaDescription)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            HStack {
                Button(action: {
                    saveChanges()
                }) {
                    Text("Save Changes")
                        .padding()
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                }

                Button(action: {
                    cancelChanges()
                }) {
                    Text("Cancel")
                        .padding()
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.red))
                }
            }
            .padding()
        }
        .padding()
    }

    private func loadImage() {
        guard let selectedImage = selectedImage else { return }
        // Additional logic if needed after selecting an image
    }

    // Logic to save changes
    private func saveChanges() {
        // Update mediaEntity with new values
        mediaEntity.title = editMediaTitle
        mediaEntity.mediaDescription = editMediaDescription
        // Update the image data if a new image is selected
        if let newImageData = selectedImage?.jpegData(compressionQuality: 1.0) {
            mediaEntity.image = newImageData
        }

        // Save changes to Core Data
        mediaViewModel.saveContext()

        // Dismiss the view
        presentationMode.wrappedValue.dismiss()
    }

    // Logic to cancel changes
    private func cancelChanges() {
        // Dismiss the view without saving changes
        presentationMode.wrappedValue.dismiss()
    }
}

struct EditMediaDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let mediaViewModel = MediaViewModel()
        let mediaEntity = MediaEntity()
        EditMediaDetailsView(mediaViewModel: mediaViewModel, mediaEntity: mediaEntity)
    }
}
