//
//  bitemapApp.swift
//  bitemap
//
//  Created by Simonas Kytra on 2023-08-29.
//

import SwiftUI

@main
struct bitemapApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
