//
//  FoodViewModel.swift
//  bitemap
//
//  Created by Simonas Kytra on 2023-09-06.
//

import Foundation
import SwiftUI
import CoreData

class FoodViewModel: ObservableObject {
    var moc: NSManagedObjectContext

    init(moc: NSManagedObjectContext) {
        self.moc = moc
    }

    func removeFood(from foods: FetchedResults<Food>, at offsets: IndexSet) {
        for index in offsets {
            let food = foods[index]
            food.wasDeleted = true
        }

        do {
            try moc.save()
        } catch {
            print("Error saving after deleting food: \(error.localizedDescription)")
        }
    }
}

