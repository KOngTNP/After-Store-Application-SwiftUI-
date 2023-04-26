//
//  afterstoreApp.swift
//  afterstore
//
//  Created by KOng's Macbook Pro on 26/4/2566 BE.
//

import SwiftUI

@main
struct afterstoreApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
