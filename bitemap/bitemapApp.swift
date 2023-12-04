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
            MainView(moc: dataController.container.viewContext)
                .environment(\.managedObjectContext, dataController.container.viewContext)
//                .environment(\.font, .custom("Avenir", size: 16))
        }
    }
}
