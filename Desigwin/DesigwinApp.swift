//
//  DesigwinApp.swift
//  Desigwin
//
//  Created by kuroisi on 2022/01/25.
//

import SwiftUI
@main
struct DesigwinApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext,
                              persistenceController.container.viewContext)
        }
    }
}
