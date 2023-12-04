//
//  DataController.swift
//  bitemap
//
//  Created by Simonas Kytra on 2023-08-31.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "bitemap")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }

        cleanupDeletedFood()
    }
    
    // since soft deletion was implemented, once the app starts all the food entries that were marked for deletion and are not linked to a food entry are deleted
    func cleanupDeletedFood() {
        let context = self.container.viewContext
        
        let request: NSFetchRequest<Food> = Food.fetchRequest()
        request.predicate = NSPredicate(format: "wasDeleted == true")
        
        do {
            let foods = try context.fetch(request)
            for food in foods {
                if food.wasDeleted {
                    let isLinkedToActiveEntry = (food.foodentry as? Set<FoodEntry> ?? []).contains { foodEntry in
                        return foodEntry.repast != nil
                    }
                    
                    if !isLinkedToActiveEntry {
                        context.delete(food)
                    }
                }
            }
            
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print("Error fetching or deleting Food objects: \(error)")
        }
    }
}
