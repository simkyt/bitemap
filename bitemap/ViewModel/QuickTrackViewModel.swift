//
//  QuickTrackViewModel.swift
//  bitemap
//
//  Created by Simonas Kytra on 01/12/2023.
//

import Foundation
import SwiftUI
import CoreData

class QuickTrackViewModel: ObservableObject {
    private var moc: NSManagedObjectContext
    @Published var repast: Repast?
    private var type: String
    private var date: Date
    
    @Published var name = ""
    
    @Published var kcal = ""
    @Published var protein = ""
    @Published var carbs = ""
    @Published var fat = ""
    
    init(moc: NSManagedObjectContext, type: String, date: Date) {
        self.moc = moc
        self.type = type
        self.date = date
    }
    
    func isNotEmpty(input: String) -> Bool {
        return !input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func localeDouble(from string: String) -> Double? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        return formatter.number(from: string)?.doubleValue
    }
    
    func isValidNum(input: String) -> Bool {
        return localeDouble(from: input).map { $0 >= 0 } ?? false
    }
    
    func isValid() -> Bool {
        let nonEmptyFields = [kcal]
        let numericFields = [kcal, protein, carbs, fat]
        
        let areNonEmptyFieldsValid = nonEmptyFields.allSatisfy(isNotEmpty)

        let areNumericFieldsValid = numericFields.allSatisfy { field in
            return field.isEmpty || isValidNum(input: field)
        }

        return areNonEmptyFieldsValid && areNumericFieldsValid
    }
    
    func fetchRepast() -> Repast? {
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
    
    func prepareFoodEntryAndRepast() -> (foodEntry: FoodEntry, repast: Repast) {
        let repast = fetchRepast() ?? Repast(context: moc)
        repast.type = type
        repast.date = date

        let newFoodEntry = FoodEntry(context: moc)
        newFoodEntry.id = UUID()
        
        let quickTrack = QuickTrack(context: moc)
        quickTrack.id = UUID()
        quickTrack.name = name.isEmpty ? "Quick track" : name
        quickTrack.kcal = round(localeDouble(from: kcal) ?? 0.0)
        quickTrack.protein = localeDouble(from: protein) ?? 0.0
        quickTrack.carbs = localeDouble(from: carbs) ?? 0.0
        quickTrack.fat = localeDouble(from: fat) ?? 0.0
        
        newFoodEntry.quicktrack = quickTrack
        newFoodEntry.repast = repast
        newFoodEntry.servingsize = quickTrack.kcal
        newFoodEntry.servingunit = "kcal"
        newFoodEntry.kcal = quickTrack.kcal
        newFoodEntry.carbs = quickTrack.carbs
        newFoodEntry.protein = quickTrack.protein
        newFoodEntry.fat = quickTrack.fat
        
        // Update repast totals
        repast.kcal += quickTrack.kcal
        repast.carbs += quickTrack.carbs
        repast.fat += quickTrack.fat
        repast.protein += quickTrack.protein
        repast.addToFoodentry(newFoodEntry)

        return (newFoodEntry, repast)
    }
    
    func addFood() {
        do {
            let (_, repast) = prepareFoodEntryAndRepast()
            
            try moc.save()
            self.repast = repast
        } catch {
            print("Error saving food to repast: \(error)")
        }
    }
}
