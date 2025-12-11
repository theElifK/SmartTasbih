//
//  CoreDataManager.swift
//  SmartTasbih
//
//  Created by Elif Karakolcu on 7.12.2025.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "SmartTasbih")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Core Data yüklenemedi: \(error.localizedDescription)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return container.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
