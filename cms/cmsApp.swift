//
//  cmsApp.swift
//  cms
//
//  Created by Ngô Ngọc Sâm on 18/2/26.
//

import SwiftUI
import CoreData

@main
struct cmsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
