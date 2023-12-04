//
//  FoodEntry+CoreDataProperties.swift
//  bitemap
//
//  Created by Simonas Kytra on 2023-09-14.
//
//

import Foundation
import CoreData


extension FoodEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodEntry> {
        return NSFetchRequest<FoodEntry>(entityName: "FoodEntry")
    }

    @NSManaged public var carbs: Double
    @NSManaged public var fat: Double
    @NSManaged public var id: UUID?
    @NSManaged public var kcal: Double
    @NSManaged public var protein: Double
    @NSManaged public var servingsize: Double
    @NSManaged public var servingunit: String?
    public var wrappedServingUnit: String {
        servingunit ?? "Unknown serving unit"
    }
    @NSManaged public var food: Food?
    @NSManaged public var quicktrack: QuickTrack?
    @NSManaged public var repast: Repast?

}

extension FoodEntry : Identifiable {

}
