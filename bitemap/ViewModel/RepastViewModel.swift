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
    @Published var DBfoods = [BMFood]()
    @Published var FSfoods = [FSFood]()
    @Published var combinedFoods = [DBFood]()
    private var fetchingDebounceTimer: Timer?
    
    var hasFoodEntries: Bool {
        if let foodEntries = repast?.foodEntryArray, !foodEntries.isEmpty {
            return true
        }
        return false
    }
    
    var moc: NSManagedObjectContext
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
    }
    
    func startSearch(searchText: String) {
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedSearchText.isEmpty {
            self.combinedFoods = []
            return
        }
        
        var foodsFromDatabase = [DBFood]()
        var foodsFromFS = [DBFood]()

        debounceFetching(searchText: searchText) {
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            self.fetchFoodsFromDatabase(searchText: searchText) { fetchedFoods in
                foodsFromDatabase = fetchedFoods
                dispatchGroup.leave()
            }

            dispatchGroup.enter()
            self.fetchFoodsFromFS(searchText: searchText) { fetchedFoods in
                foodsFromFS = fetchedFoods
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main) {
                self.combinedFoods = foodsFromDatabase + foodsFromFS
            }
        }
    }
    func debounceFetching(searchText: String, fetchingFunctions: @escaping () -> Void) {
        fetchingDebounceTimer?.invalidate()
        fetchingDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
            fetchingFunctions()
        }
    }
    
    func fetchFoodsFromDatabase(searchText: String, completion: @escaping ([DBFood]) -> Void) {
        NetworkManager.fetchFoodFromDatabase(food: searchText) { fetchedFoods in
            DispatchQueue.main.async {
                completion(fetchedFoods)
            }
        }
    }

    func fetchFoodsFromFS(searchText: String, completion: @escaping ([DBFood]) -> Void) {
        NetworkManager.fetchFoodFromFS(food: searchText) { fetchedFoods in
            DispatchQueue.main.async {
                if let fsFoods = fetchedFoods.foods?.food?.filter({ $0.size != 0 }) {
                    completion(fsFoods)
                } else {
                    completion([])
                }
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
    
    func createTemporaryFoodEntry(food: DBFood, type: String, date: Date) -> FoodEntry? {
        do {
            let food = try fetchOrCreateFood(from: food)
            let result = prepareFoodEntryAndRepast(type: type, date: date, food: food)
            return result.foodEntry
        } catch {
            print("Error fetching or creating food: \(error)")
            return nil
        }
    }
    
    func fetchOrCreateFood<T: DBFood>(from food: T) throws -> Food {
        let fetchRequest: NSFetchRequest<Food> = Food.fetchRequest()
        let predicate = NSPredicate(format: "name == %@ AND brand == %@ AND serving == %@ AND perserving == %@ AND carbs == %f AND fat == %@ AND kcal == %f AND protein == %f AND #size == %@",
                                    food.name, food.brand ?? "", food.serving, food.perserving, food.carbs, NSNumber(value: food.fat), food.kcal, food.protein, NSNumber(value: food.size))
        fetchRequest.predicate = predicate

        do {
            let existingFoods = try moc.fetch(fetchRequest)
            if existingFoods.isEmpty {
                return FoodConverter.convertToFood(moc: moc, food: food)
            } else {
                return existingFoods.first!
            }
        } catch {
            print("Error fetching food: \(error)")
            throw error
        }
    }
    
    func prepareFoodEntryAndRepast(type: String, date: Date, food: Food) -> (foodEntry: FoodEntry, repast: Repast) {
        let repast = fetchRepast(for: type, date: date) ?? Repast(context: moc)
        repast.type = type
        repast.date = date

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
        
        // Update repast totals
        repast.kcal += food.kcal
        repast.carbs += food.carbs
        repast.fat += food.fat
        repast.protein += food.protein
        repast.addToFoodentry(newFoodEntry)

        return (newFoodEntry, repast)
    }
    
    func addDatabaseFood<T: DBFood>(type: String, date: Date, food: T) {
        do {
            let newOrExistingFood = try fetchOrCreateFood(from: food)
            addFood(type: type, date: date, food: newOrExistingFood)
        } catch {
            print("Error in addDatabaseFood: \(error)")
        }
    }
    
    func addFood(type: String, date: Date, food: Food) {
        do {
            let (_, repast) = prepareFoodEntryAndRepast(type: type, date: date, food: food)
            
            try moc.save()
            self.repast = repast
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
            
            if let quickTrack = foodEntryToDelete.quicktrack {
                moc.delete(quickTrack)
            }
            
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
