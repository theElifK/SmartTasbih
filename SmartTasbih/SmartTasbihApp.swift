//
//  SmartTasbihApp.swift
//  SmartTasbih
//
//  Created by Elif Karakolcu on 7.12.2025.
//

import SwiftUI
import CoreData

@main
struct SmartTasbihApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
