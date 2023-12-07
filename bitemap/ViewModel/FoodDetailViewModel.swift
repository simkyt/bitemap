//
//  FoodAddViewModel.swift
//  bitemap
//
//  Created by Simonas Kytra on 2023-09-05.
//

import Foundation
import SwiftUI
import CoreData

class FoodDetailViewModel: ObservableObject {
    private var moc: NSManagedObjectContext

    @Published var name = ""
    @Published var brand = ""
    
    private var initialSubcategoryID = 0
    private var initialCategoryID = 0
    @Published var category = ""
    @Published var categoryID = 0
    @Published var subcategoryID = 0
    
    @Published var serving = 1
    let servingTypes = ["Small serving", "Standard serving", "Large serving"]
 
    @Published var perserving = 0
    let servingContents = ["g", "ml"]
    
    @Published var size = ""
    @Published var kcal = ""
    @Published var protein = ""
    @Published var carbs = ""
    @Published var fat = ""
    
    @Published private(set) var categories = [DBCategory]()
    @Published private(set) var subcategories = [DBSubcategory]()
    
    enum Mode {
        case add
        case edit(Food)
    }
    
    private var mode: Mode
    
    var buttonTitle: String {
        switch mode {
        case .add:
            return "Add"
        case .edit:
            return "Update"
        }
    }
    
    init(moc: NSManagedObjectContext, mode: Mode) {
        self.moc = moc
        self.mode = mode
        loadCategories()
        loadSubcategories()
        
        if case .edit(let food) = mode {
            self.name = food.wrappedName
            if food.wrappedBrand == "Unknown brand" {
                self.brand = ""
            } else {
                self.brand = food.wrappedBrand
            }
            
            self.category = food.wrappedCategory
            guard let matchingSubcategory = subcategories.first(where: { $0.name == self.category }) else {
                return
            }
            
            self.categoryID = matchingSubcategory.categoryID
            self.subcategoryID = matchingSubcategory.id
            self.initialSubcategoryID = subcategoryID
            self.initialCategoryID = categoryID
            
            self.serving = servingTypes.firstIndex(of: food.wrappedServing) ?? 1
            self.perserving = servingContents.firstIndex(of: food.wrappedPerServing) ?? 0
            
            self.size = NumberFormatter.customDecimalFormatter.string(from: food.size)
            self.kcal = NumberFormatter.customDecimalFormatter.string(from: round(food.kcal / food.size * 100))
            self.protein = NumberFormatter.customDecimalFormatter.string(from: food.protein / food.size * 100)
            self.carbs = NumberFormatter.customDecimalFormatter.string(from: food.carbs / food.size * 100)
            self.fat = NumberFormatter.customDecimalFormatter.string(from: food.fat / food.size * 100)
        }
    }
    
    func loadCategories() {
        guard let url = Bundle.main.url(forResource: "categories", withExtension: "json") else {
            fatalError("Failed to locate categories.json in bundle.")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load categories.json from bundle.")
        }
        let decoder = JSONDecoder()
        guard let categories = try? decoder.decode([DBCategory].self, from: data) else {
            fatalError("Failed to decode categories.json from bundle.")
        }
        self.categories = categories
    }
    
    func loadSubcategories() {
        guard let url = Bundle.main.url(forResource: "subcategories", withExtension: "json") else {
            fatalError("Failed to locate subcategories.json in bundle.")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load subcategories.json from bundle.")
        }
        let decoder = JSONDecoder()
        guard let subcategories = try? decoder.decode([DBSubcategory].self, from: data) else {
            fatalError("Failed to decode subcategories.json from bundle.")
        }
        self.subcategories = subcategories
    }
    
//    func fetchCategoriesFromDatabase() {
//        NetworkManager.fetchCategoriesFromDatabase() { fetchedCategories in
//            DispatchQueue.main.async {
//                self.categories = fetchedCategories
//                print(self.categories)
//            }
//        }
//    }
//    
//    func fetchSubcategoriesFromDatabase(id: Int) {
//        NetworkManager.fetchSubcategoriesFromDatabase(id: id) { fetchedSubcategories in
//            DispatchQueue.main.async {
//                self.subcategories = fetchedSubcategories
//                print(self.subcategories)
//            }
//        }
//    }
    
    func isNotEmpty(input: String) -> Bool {
        return !input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func localeDouble(from string: String) -> Double? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: string)?.doubleValue
    }
    
    func isValidNum(input: String) -> Bool {
        return localeDouble(from: input).map { $0 >= 0 } ?? false
    }

    func isValidSize(input: String) -> Bool {
        guard let number = localeDouble(from: input) else {
            return false
        }
        return floor(number) == number && number > 0
    }
    
    func isValid() -> Bool {
        let nonEmptyFields = [name, size, kcal, protein, carbs, fat]
        let numericFields = [kcal, protein, carbs, fat]
        
        return nonEmptyFields.allSatisfy(isNotEmpty) && numericFields.allSatisfy(isValidNum) && isValidSize(input: size) && !category.isEmpty
    }
    
    func getValuePer(input: String) -> Double {
        guard let inputValue = localeDouble(from: input), let sizeValue = localeDouble(from: size) else {
            return 0.0
        }
        return (inputValue * sizeValue) / 100
    }
    
    func saveFood() {
        if case .add = mode {
            addFood()
        } else if case .edit(let food) = mode {
            updateFood(food)
        }
    }
    
    func addFood() {
        let food = Food(context: moc)
        food.id = UUID()
        food.name = name
        food.category = category
        
        if brand == "" {
            food.brand = nil
        } else {
            food.brand = brand
        }
        
        food.serving = servingTypes[serving]
        food.perserving = servingContents[perserving]
        
        food.size = localeDouble(from: size) ?? 0.0
        food.kcal = round(getValuePer(input: kcal)) // using round as a temporary solution, should probably change kcal to integer everywhere in the future
        food.protein = getValuePer(input: protein)
        food.carbs = getValuePer(input: carbs)
        food.fat = getValuePer(input: fat)
        
        food.wasDeleted = false
        food.isFromDatabase = false
        
        try? moc.save()
        
        let dbFood = FoodConverter.convertFoodToDBFood(food, newSubcategoryID: self.subcategoryID)
        NetworkManager.postFoodToDatabase(categoryId: self.categoryID, subcategoryId: self.subcategoryID, dbFood: dbFood)
    }
    
    func updateFood(_ food: Food) {
        food.name = name
        food.category = category
        
        if brand == "" {
            food.brand = nil
        } else {
            food.brand = brand
        }
        
        food.serving = servingTypes[serving]
        food.perserving = servingContents[perserving]
        
        food.size = Double(size) ?? 0.0
        
        print(kcal)
        food.kcal = round(getValuePer(input: kcal)) // using round as a temporary solution, should probably change kcal to integer everywhere in the future
        food.protein = getValuePer(input: protein)
        food.carbs = getValuePer(input: carbs)
        food.fat = getValuePer(input: fat)
        
        let foodEntryFetchRequest: NSFetchRequest<FoodEntry> = FoodEntry.fetchRequest()
        foodEntryFetchRequest.predicate = NSPredicate(format: "food == %@", food)

        do {
            let foodEntries = try moc.fetch(foodEntryFetchRequest)
            
            for foodEntry in foodEntries {
                foodEntry.servingunit = "\(food.wrappedServing) (\(NumberFormatter.customDecimalFormatter.string(from: food.size)) \(food.wrappedPerServing))"
                let trackedFoodDetailVM = TrackedFoodDetailViewModel(moc: moc, foodEntry: foodEntry)
                
                trackedFoodDetailVM.updateTemporaryValues()
                
                trackedFoodDetailVM.saveChanges()
            }

            try moc.save()

        } catch {
            print("Error: \(error)")
        }
        
        let dbFood: BMFood
        
        if initialSubcategoryID == subcategoryID {
            dbFood = FoodConverter.convertFoodToDBFood(food, newSubcategoryID: initialSubcategoryID)
        } else {
            dbFood = FoodConverter.convertFoodToDBFood(food, newSubcategoryID: self.subcategoryID)
        }

        NetworkManager.updateFoodInDatabase(categoryId: initialCategoryID, subcategoryId: initialSubcategoryID, dbFood: dbFood)
    }
}
