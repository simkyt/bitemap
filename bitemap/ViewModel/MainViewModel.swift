//
//  ContentViewModel.swift
//  bitemap
//
//  Created by Simonas Kytra on 26/11/2023.
//

import Foundation
import SwiftUI
import CoreData

class MainViewModel: ObservableObject {
    @Published var totalCalories: Double = 0
    @Published var totalCarbs: Double = 0
    @Published var totalProtein: Double = 0
    @Published var totalFat: Double = 0
    
    @Published var breakfastCalories: Double = 0
    @Published var lunchCalories: Double = 0
    @Published var dinnerCalories: Double = 0
    @Published var snacksCalories: Double = 0

    private var moc: NSManagedObjectContext

    init(moc: NSManagedObjectContext, date: Date) {
        self.moc = moc
        calculateTotalCalories(for: date)
    }
    
    func calculateTotalCalories(for date: Date) {
        let types = ["Breakfast", "Lunch", "Dinner", "Snacks"]
        var totalCalories: Double = 0
        var totalCarbs: Double = 0
        var totalProtein: Double = 0
        var totalFat: Double = 0
        var mealCalories = [String: Double]()

        for type in types {
            let request: NSFetchRequest<Repast> = Repast.fetchRequest()
            request.predicate = NSPredicate(format: "type == %@ AND date == %@", type, date as NSDate)
            request.fetchLimit = 1

            if let result = try? moc.fetch(request).first {
                totalCalories += result.kcal
                totalCarbs += result.carbs
                totalProtein += result.protein
                totalFat += result.fat
                mealCalories[type] = result.kcal
            } else {
                mealCalories[type] = 0
            }
        }

        self.totalCalories = totalCalories
        self.totalCarbs = totalCarbs
        self.totalProtein = totalProtein
        self.totalFat = totalFat
        
        self.breakfastCalories = mealCalories["Breakfast"] ?? 0
        self.lunchCalories = mealCalories["Lunch"] ?? 0
        self.dinnerCalories = mealCalories["Dinner"] ?? 0
        self.snacksCalories = mealCalories["Snacks"] ?? 0
    }
}

