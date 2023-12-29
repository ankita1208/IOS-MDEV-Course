//
//  TravelPlanner
//
//  Created by ankita sharma on 03/12/23.
//
import SwiftUI
import CoreData

struct AddMediaView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.mediaEntityContext) private var mediaEntityContext
    @EnvironmentObject private var mediaViewModel: MediaViewModel

    @State private var selectedImage: UIImage?
    @State private var mediaTitle = ""
    @State private var mediaDescription = ""
    @State private var isImagePickerPresented = false

    var body: some View {
        VStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(Rectangle())
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .foregroundColor(.gray)
            }

            Button(action: {
                isImagePickerPresented.toggle()
            }) {
                HStack {
                    Image(systemName: "photo.on.rectangle.angled")
                    Text("Select Media")
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
            }
            .padding()

            TextField("Media Title", text: $mediaTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Media Description", text: $mediaDescription)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                saveMediaToDatabase()
            }) {
                Text("Add Media")
                    .padding()
                    .foregroundColor(Color(hex: "5d9d79"))
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
            }
            .padding()
        }
        .padding()
        .navigationTitle("Add Media")
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $selectedImage)
                .onDisappear {
                    if let uiImage = selectedImage {
                        selectedImage = uiImage
                        // Save the selected image data to UserDefaults
                        UserDefaults.standard.set(uiImage.jpegData(compressionQuality: 1.0), forKey: "selectedImageData")
                    }
                }
        }
        .onAppear {
            // Load the selected image data from UserDefaults when the view appears
            if let imageData = UserDefaults.standard.data(forKey: "selectedImageData") {
                selectedImage = UIImage(data: imageData)
            }
        }
    }

    private func saveMediaToDatabase() {
        guard let selectedImage = selectedImage else {
            return
        }

        let newMedia = MediaEntity(context: mediaEntityContext)
        newMedia.id = UUID()
        newMedia.title = mediaTitle
        newMedia.mediaDescription = mediaDescription
        newMedia.image = selectedImage.jpegData(compressionQuality: 1.0)
        newMedia.mediaUrl = nil

        do {
            try viewContext.save()
            print("Saved Media: \(newMedia)")
            
            // Reset the fields
            mediaTitle = ""
            mediaDescription = ""
            self.selectedImage = nil

            // Update the mediaList array directly
            mediaViewModel.addMedia(newMedia)

            // Dismiss the current view and navigate to the previous screen
            presentationMode.wrappedValue.dismiss()
        } catch {
            let nsError = error as NSError
            print("Error saving media: \(nsError), \(nsError.userInfo)")
            // Add additional error handling as needed
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
