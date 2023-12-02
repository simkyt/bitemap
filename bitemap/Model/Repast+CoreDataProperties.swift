//
//  Repast+CoreDataProperties.swift
//  bitemap
//
//  Created by Simonas Kytra on 2023-09-14.
//
//

import Foundation
import CoreData


extension Repast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Repast> {
        return NSFetchRequest<Repast>(entityName: "Repast")
    }

    @NSManaged public var carbs: Double
    @NSManaged public var date: Date?
    @NSManaged public var fat: Double
    @NSManaged public var kcal: Double
    @NSManaged public var protein: Double
    @NSManaged public var type: String?
    public var wrappedType: String {
             type ?? "Unknown type"
         }
    @NSManaged public var foodentry: NSSet?
    public var foodEntryArray: [FoodEntry] {
        let set = foodentry as? Set<FoodEntry> ?? []
        return set.sorted {
            $0.id < $1.id
        }
    }
}

// MARK: Generated accessors for foodentry
extension Repast {

    @objc(addFoodentryObject:)
    @NSManaged public func addToFoodentry(_ value: FoodEntry)

    @objc(removeFoodentryObject:)
    @NSManaged public func removeFromFoodentry(_ value: FoodEntry)

    @objc(addFoodentry:)
    @NSManaged public func addToFoodentry(_ values: NSSet)

    @objc(removeFoodentry:)
    @NSManaged public func removeFromFoodentry(_ values: NSSet)

}

extension Repast : Identifiable {

}
