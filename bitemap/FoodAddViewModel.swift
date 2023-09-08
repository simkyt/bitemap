//
//  FoodAddViewModel.swift
//  bitemap
//
//  Created by Simonas Kytra on 2023-09-05.
//

import Foundation
import SwiftUI
import CoreData

class FoodAddViewModel: ObservableObject {
    var moc: NSManagedObjectContext

    @Published var name = ""
    @Published var brand = ""
    @Published var category = ""
    
    @Published var serving = 1
    let servingTypes = ["Small serving", "Standard serving", "Large serving"]
 
    @Published var perserving = 0
    let servingContents = ["g", "ml"]
    
    @Published var size = ""
    @Published var kcal = ""
    @Published var protein = ""
    @Published var carbs = ""
    @Published var fat = ""
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
    }
    
    func isNotEmpty(input: String) -> Bool {
        return !input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func isValidNum(input: String) -> Bool {
        return Double(input).map { $0 > 0 } ?? false
    }
    
    func isValid() -> Bool {
        let nonEmptyFields = [name, size, kcal, protein, carbs, fat]
        let numericFields = [size, kcal, protein, carbs, fat]
        
        return nonEmptyFields.allSatisfy(isNotEmpty) && numericFields.allSatisfy(isValidNum)
    }
    
    func getValuePer(input: String) -> Double {
        return (Double(input)! * Double(size)!) / 100
    }
    
    func addFood() {
        let food = Food(context: moc)
        food.id = UUID()
        food.name = name
        food.brand = brand
        
        food.serving = servingTypes[serving]
        food.perserving = servingContents[perserving]
        
        food.size = Double(size)!
        
        food.kcal = getValuePer(input: kcal)
        food.protein = getValuePer(input: protein)
        food.carbs = getValuePer(input: carbs)
        food.fat = getValuePer(input: fat)
        
        try? moc.save()
    }
}
