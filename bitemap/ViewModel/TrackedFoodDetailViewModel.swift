//
//  TrackedFoodDetailViewModel.swift
//  bitemap
//
//  Created by Simonas Kytra on 29/11/2023.
//

import Foundation
import SwiftUI
import CoreData

class TrackedFoodDetailViewModel: ObservableObject {
    private var moc: NSManagedObjectContext
    @Published var servingSizeText: String = ""
    @Published var temporaryServingUnit: String = ""
    @Published var temporaryKcal: Double = 0
    @Published var temporaryCarbs: Double = 0
    @Published var temporaryProtein: Double = 0
    @Published var temporaryFat: Double = 0
    @Published var trackingSaved = false
    
    var isServingSizeValid: Bool {
        let formattedServingSizeText = servingSizeText.replacingOccurrences(of: ",", with: ".")
        guard let _ = Double(formattedServingSizeText) else {
            return false
        }
        return true
    }
    
    private let formatter = NumberFormatter()

    private(set) var foodEntry: FoodEntry

    init(moc: NSManagedObjectContext, foodEntry: FoodEntry) {
        self.moc = moc
        self.foodEntry = foodEntry
        
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        
        self.servingSizeText = NumberFormatter.customDecimalFormatter.string(from: foodEntry.servingsize)
        self.temporaryServingUnit = foodEntry.wrappedServingUnit
        self.temporaryKcal = foodEntry.kcal
        self.temporaryCarbs = foodEntry.carbs
        self.temporaryProtein = foodEntry.protein
        self.temporaryFat = foodEntry.fat
    }
    
    func updateTemporaryValues() {
        if let number = formatter.number(from: servingSizeText) {
            var newServingSize = number.doubleValue
            if newServingSize == 0 {
                newServingSize = foodEntry.servingsize
            }
            
            if temporaryServingUnit != "Grams" {
                temporaryKcal = round(foodEntry.food!.kcal * newServingSize)
                temporaryCarbs = foodEntry.food!.carbs * newServingSize
                temporaryProtein = foodEntry.food!.protein * newServingSize
                temporaryFat = foodEntry.food!.fat * newServingSize
            } else {
                let foodSize = foodEntry.food!.size
                temporaryKcal = round((foodEntry.food!.kcal / foodSize) * newServingSize)
                temporaryCarbs = (foodEntry.food!.carbs / foodSize) * newServingSize
                temporaryProtein = (foodEntry.food!.protein / foodSize) * newServingSize
                temporaryFat = (foodEntry.food!.fat / foodSize) * newServingSize
            }
        }
    }
    
    func saveChanges() {
        if let number = formatter.number(from: servingSizeText) {
            var newServingSize = number.doubleValue
            if newServingSize == 0 {
                newServingSize = foodEntry.servingsize
            }
            
            foodEntry.repast!.kcal -= foodEntry.kcal
            foodEntry.repast!.carbs -= foodEntry.carbs
            foodEntry.repast!.fat -= foodEntry.fat
            foodEntry.repast!.protein -= foodEntry.protein
            
            foodEntry.servingsize = newServingSize
            foodEntry.servingunit = temporaryServingUnit
            foodEntry.kcal = temporaryKcal
            foodEntry.carbs = temporaryCarbs
            foodEntry.protein = temporaryProtein
            foodEntry.fat = temporaryFat
            
            foodEntry.repast!.kcal += foodEntry.kcal
            foodEntry.repast!.carbs += foodEntry.carbs
            foodEntry.repast!.fat += foodEntry.fat
            foodEntry.repast!.protein += foodEntry.protein
            
            trackingSaved = true
            try? moc.save()
        }
    }
    
    func deleteFoodEntry() {
        foodEntry.repast!.kcal -= foodEntry.kcal
        foodEntry.repast!.carbs -= foodEntry.carbs
        foodEntry.repast!.fat -= foodEntry.fat
        foodEntry.repast!.protein -= foodEntry.protein
        foodEntry.repast!.removeFromFoodentry(foodEntry)
        
        moc.delete(foodEntry)
        try? moc.save()
    }
}
