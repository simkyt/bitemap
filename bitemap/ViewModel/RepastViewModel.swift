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
    @Published var DBfoods = [DBFood]()
    @Published var FSfoods = [FSFood]()
    
    var moc: NSManagedObjectContext
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
    }
    
    func fetchFoodsFromDatabase(searchText: String) {
        NetworkManager.fetchFoodFromDatabase(food: searchText) { fetchedFoods in
            DispatchQueue.main.async {
                self.DBfoods = fetchedFoods
                print(self.DBfoods)
            }
        }
    }
    
    func fetchFoodsFromFS(searchText: String) {
        NetworkManager.fetchFoodFromFS(food: searchText) { fetchedFoods in
            DispatchQueue.main.async {
                self.FSfoods = fetchedFoods.foods?.food?.filter { $0.size != 0 } ?? [FSFood]()
                print(self.FSfoods)
            }
        }
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
    
    func addDatabaseFood<T: StandardFood>(type: String, date: Date, food: T) {
        let fetchRequest: NSFetchRequest<Food> = Food.fetchRequest()
        
        let predicate = NSPredicate(format: "name == %@ AND brand == %@ AND serving == %@ AND perserving == %@ AND carbs == %f AND fat == %@ AND kcal == %f AND protein == %f AND #size == %@",
                                    food.name, food.brand ?? "", food.serving, food.perserving, food.carbs, NSNumber(value: food.fat), food.kcal, food.protein, NSNumber(value: food.size))
        fetchRequest.predicate = predicate
        
        do {
            let existingFoods = try moc.fetch(fetchRequest)
            if existingFoods.isEmpty {
                let newFood = Converter.convertToFood(moc: moc, food: food)
                addFood(type: type, date: date, food: newFood)
            } else {
                addFood(type: type, date: date, food: existingFoods.first!)
            }
        } catch {
            print("Error fetching food: \(error)")
        }
    }
    
//    func addDBFood(type: String, date: Date, dbFood: DBFood) {
//        let fetchRequest: NSFetchRequest<Food> = Food.fetchRequest()
//        
//        let predicate = NSPredicate(format: "name == %@ AND brand == %@ AND serving == %@ AND perserving == %@ AND carbs == %f AND fat == %@ AND kcal == %f AND protein == %f AND #size == %@",
//                                    dbFood.name, dbFood.brand ?? "", dbFood.serving, dbFood.perserving, dbFood.carbs, NSNumber(value: dbFood.fat), dbFood.kcal, dbFood.protein, NSNumber(value: dbFood.size))
//        fetchRequest.predicate = predicate
//        
//        do {
//            let existingFoods = try moc.fetch(fetchRequest)
//            if existingFoods.isEmpty {
//                let newFood = Converter.convertDBFoodToFood(moc: moc, dbFood)
//                addFood(type: type, date: date, food: newFood)
//            } else {
//                addFood(type: type, date: date, food: existingFoods.first!)
//            }
//        } catch {
//            print("Error fetching food: \(error)")
//        }
//    }
//    
//    func addFSFood(type: String, date: Date, fsFood: FSFood) {
//        let fetchRequest: NSFetchRequest<Food> = Food.fetchRequest()
//        
//        let predicate = NSPredicate(format: "name == %@ AND brand == %@ AND serving == %@ AND perserving == %@ AND carbs == %f AND fat == %@ AND kcal == %f AND protein == %f AND #size == %@",
//                                    fsFood.name, fsFood.brand ?? "", fsFood.serving, fsFood.perserving, fsFood.carbs, NSNumber(value: fsFood.fat), fsFood.kcal, fsFood.protein, NSNumber(value: fsFood.size))
//        fetchRequest.predicate = predicate
//        
//        do {
//            let existingFoods = try moc.fetch(fetchRequest)
//            if existingFoods.isEmpty {
//                let newFood = Converter.convertFSFoodToFood(moc: moc, fsFood)
//                addFood(type: type, date: date, food: newFood)
//            } else {
//                addFood(type: type, date: date, food: existingFoods.first!)
//            }
//        } catch {
//            print("Error fetching food: \(error)")
//        }
//    }
    
    func addFood(type: String, date: Date, food: Food) {
        do {
            if let existingRepast = fetchRepast(for: type, date: date) {
                let newFoodEntry = FoodEntry(context: moc)
                newFoodEntry.id = UUID()
                newFoodEntry.food = food
                newFoodEntry.repast = existingRepast
                newFoodEntry.servingsize = 1
                newFoodEntry.servingunit = "\(food.wrappedServing) (\(NumberFormatter.customDecimalFormatter.string(from: food.size)) \(food.wrappedPerServing))"
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
                newFoodEntry.servingsize = 1
                newFoodEntry.servingunit = "\(food.wrappedServing) (\(NumberFormatter.customDecimalFormatter.string(from: food.size)) \(food.wrappedPerServing))"
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
            
            // somewhere somehow double values mess up (end result could be carbs = -0.0000000000000014)
            if repast.kcal < 0 { repast.kcal = 0 }
            if repast.carbs < 0 { repast.carbs = 0 }
            if repast.fat < 0 { repast.fat = 0 }
            if repast.protein < 0 { repast.protein = 0 }
            
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
