//
//  RepastViewModel.swift
//  bitemap
//
//  Created by Simonas Kytra on 2023-09-09.
//

import Foundation
import SwiftUI
import CoreData

class RepastViewModel: ObservableObject {
    @Published var repast: Repast?
    
    var moc: NSManagedObjectContext
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
    }
    
    func loadRepast(for type: String, date: Date) {
        repast = fetchRepast(for: type, date: date)
    }
    
    func fetchRepast(for type: String, date: Date) -> Repast? {
        let fetchRequest: NSFetchRequest<Repast> = Repast.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "type == %@ AND date == %@", type, date as NSDate)
        fetchRequest.fetchLimit = 1

        do {
            return try moc.fetch(fetchRequest).first
        } catch {
            print("Error fetching repast: \(error)")
            return nil
        }
    }
    
    func addFood(type: String, date: Date, food: Food) {
        do {
            if let existingRepast = fetchRepast(for: type, date: date) {
                let newFoodEntry = FoodEntry(context: moc)
                newFoodEntry.id = UUID()
                newFoodEntry.food = food
                newFoodEntry.repast = existingRepast
                newFoodEntry.servingsize = food.size
                newFoodEntry.kcal = food.kcal
                newFoodEntry.carbs = food.carbs
                newFoodEntry.protein = food.protein
                newFoodEntry.fat = food.fat
                existingRepast.addToFoodentry(newFoodEntry)
                existingRepast.kcal += food.kcal
                existingRepast.carbs += food.carbs
                existingRepast.fat += food.fat
                existingRepast.protein += food.protein
                
                try moc.save()
                
                repast = existingRepast
            } else {
                let repast = Repast(context: moc)
                repast.type = type
                repast.date = date

                repast.kcal = food.kcal
                repast.carbs = food.carbs
                repast.fat = food.fat
                repast.protein = food.protein

                let newFoodEntry = FoodEntry(context: moc)
                newFoodEntry.id = UUID()
                newFoodEntry.food = food
                newFoodEntry.repast = repast
                newFoodEntry.servingsize = food.size
                newFoodEntry.kcal = food.kcal
                newFoodEntry.carbs = food.carbs
                newFoodEntry.protein = food.protein
                newFoodEntry.fat = food.fat
                repast.addToFoodentry(newFoodEntry)

                try moc.save()
                
                self.repast = repast
            }
        } catch {
            print("Error saving food to repast: \(error)")
        }
    }
    
    func removeFoodEntry(at offsets: IndexSet) {
        guard let repast = repast else { return }
        
        for index in offsets {
            let foodEntryToDelete = repast.foodEntryArray[index]
            
            repast.kcal -= foodEntryToDelete.kcal
            repast.carbs -= foodEntryToDelete.carbs
            repast.fat -= foodEntryToDelete.fat
            repast.protein -= foodEntryToDelete.protein
            
            repast.removeFromFoodentry(foodEntryToDelete)
            
            moc.delete(foodEntryToDelete)
            
        }
        
        do {
            try moc.save()
            self.repast = repast
        } catch {
            print("Error removing food entry: \(error)")
        }
    }
}
