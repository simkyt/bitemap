//
//  FoodViewModel.swift
//  bitemap
//
//  Created by Simonas Kytra on 2023-09-06.
//

import Foundation
import SwiftUI
import CoreData

class CustomFoodViewModel: ObservableObject {
    var moc: NSManagedObjectContext

    @Published var foods: [Food] = []
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
        fetchFoods()
    }

    func fetchFoods() {
        let request: NSFetchRequest<Food> = Food.fetchRequest()
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "wasDeleted == %@ AND isFromDatabase == %@", NSNumber(value: false), NSNumber(value: false))

        do {
            foods = try moc.fetch(request)
        } catch {
            print("Error fetching foods: \(error.localizedDescription)")
        }
    }
    
    func removeFood(at offsets: IndexSet) {
        for index in offsets {
            let food = foods[index]
            food.wasDeleted = true
        }
        
        do {
            try moc.save()
            foods.remove(atOffsets: offsets)
        } catch {
            print("Error saving after deleting food: \(error.localizedDescription)")
        }
    }
}

