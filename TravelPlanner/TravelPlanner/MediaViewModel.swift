// MediaViewModel.swift

import SwiftUI
import CoreData

class MediaViewModel: ObservableObject {
    @Published var mediaItems: [MediaItem] = []
    @Published var mediaList: [MediaEntity] = []

    func addMedia(_ media: MediaEntity) {
        mediaList.append(media)
    }

    func fetchMediaItems() {
        let context = PersistenceController.shared.mediaEntityContainer.viewContext

        do {
            mediaList = try context.fetch(MediaEntity.fetchRequest())
        } catch {
            print("Error fetching media items from Core Data: \(error.localizedDescription)")
        }
    }
    func saveContext() {
        let context = PersistenceController.shared.mediaEntityContainer.viewContext
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error.localizedDescription)")
            }
        }

    func getImageData(for mediaEntity: MediaEntity) -> Data? {
        return mediaEntity.image
    }
    class Wrapper: ObservableObject {
            @Published var mediaViewModel = MediaViewModel()
        }
}

struct MediaItem: Identifiable, Decodable {
    let id: Int
    let title: String
    let description: String
    let imageUrl: String
    let image:Data
}
