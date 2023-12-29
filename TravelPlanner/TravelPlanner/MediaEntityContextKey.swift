//
//  MediaEntityContextKey.swift
//  TravelPlanner
//
//  Created by ankita sharma on 04/12/23.
//

import SwiftUI
import CoreData

struct MediaEntityContextKey: EnvironmentKey {
    static var defaultValue: NSManagedObjectContext = PersistenceController.shared.mediaEntityContainer.viewContext
}

extension EnvironmentValues {
    var mediaEntityContext: NSManagedObjectContext {
        get { self[MediaEntityContextKey.self] }
        set { self[MediaEntityContextKey.self] = newValue }
    }
}
