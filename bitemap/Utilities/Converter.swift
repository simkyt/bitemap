//
//  Converter.swift
//  bitemap
//
//  Created by Simonas Kytra on 01/12/2023.
//

import SwiftUI
import CoreData

class Converter {
    static func convertFoodToDBFood(_ food: Food, newSubcategoryID: Int) -> DBFood {
        return DBFood(
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
    
    static func convertToFood(moc: NSManagedObjectContext, food: StandardFood) -> Food {
        let newFood = Food(context: moc)
        newFood.id = UUID(uuidString: food.id) // Handle UUID generation for FSFood differently if needed.
        newFood.name = food.name
        newFood.brand = food.brand
        newFood.carbs = food.carbs
        newFood.fat = food.fat
        newFood.kcal = food.kcal
        newFood.protein = food.protein
        newFood.serving = food.serving
        newFood.size = food.size
        newFood.perserving = food.perserving
        newFood.isFromDatabase = true
        
        return newFood
    }
    
//    static func convertDBFoodToFood(moc: NSManagedObjectContext, _ dbFood: DBFood) -> Food {
//        let newFood = Food(context: moc)
//        newFood.id = UUID(uuidString: dbFood.id)
//        newFood.name = dbFood.name
//        newFood.brand = dbFood.brand
//        newFood.carbs = dbFood.carbs
//        newFood.fat = dbFood.fat
//        newFood.kcal = dbFood.kcal
//        newFood.protein = dbFood.protein
//        newFood.serving = dbFood.serving
//        newFood.size = dbFood.size
//        newFood.perserving = dbFood.perserving
//        newFood.isFromDatabase = true
//        
//        return newFood
//    }
//    
//    static func convertFSFoodToFood(moc: NSManagedObjectContext, _ fsFood: FSFood) -> Food {
//        let newFood = Food(context: moc)
//        newFood.id = UUID()
//        newFood.name = fsFood.name
//        newFood.brand = fsFood.brand
//        newFood.carbs = fsFood.carbs
//        newFood.fat = fsFood.fat
//        newFood.kcal = fsFood.kcal
//        newFood.protein = fsFood.protein
//        newFood.serving = fsFood.serving
//        newFood.size = fsFood.size
//        newFood.perserving = fsFood.perserving
//        newFood.isFromDatabase = true
//        
//        return newFood
//    }
}

