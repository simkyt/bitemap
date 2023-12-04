//
//  Converter.swift
//  bitemap
//
//  Created by Simonas Kytra on 01/12/2023.
//

import SwiftUI
import CoreData

class FoodConverter {
    static func convertFoodToDBFood(_ food: Food, newSubcategoryID: Int) -> BMFood {
        return BMFood(
            brand: (food.wrappedBrand == "Unknown brand" ? "" : food.wrappedBrand),
            carbs: food.carbs,
            fat: food.fat,
            id: food.id!.uuidString,
            kcal: food.kcal,
            name: food.wrappedName,
            perserving: food.wrappedPerServing,
            protein: food.protein,
            serving: food.wrappedServing,
            size: food.size,
            subcategoryID: newSubcategoryID
        )
    }
    
    static func convertToFood(moc: NSManagedObjectContext, food: DBFood) -> Food {
        let newFood = Food(context: moc)
        newFood.id = UUID(uuidString: food.id) ?? UUID()
        newFood.name = food.name
        newFood.brand = food.brand
        newFood.carbs = food.carbs
        newFood.fat = food.fat
        newFood.kcal = food.kcal
        newFood.protein = food.protein
        newFood.serving = food.serving
        newFood.size = food.size
        newFood.perserving = food.perserving
        newFood.wasDeleted = true
        newFood.isFromDatabase = true
        
        return newFood
    }
}

