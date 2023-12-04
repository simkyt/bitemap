//
//  Food+CoreDataProperties.swift
//  bitemap
//
//  Created by Simonas Kytra on 2023-09-14.
//
//

import Foundation
import CoreData


extension Food {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Food> {
        return NSFetchRequest<Food>(entityName: "Food")
    }

    @NSManaged public var brand: String?
    public var wrappedBrand: String {
        brand ?? "Unknown brand"
    }
    @NSManaged public var carbs: Double
    @NSManaged public var category: String?
    public var wrappedCategory: String {
        category ?? "Unknown category"
    }
    @NSManaged public var fat: Double
    @NSManaged public var id: UUID?
    @NSManaged public var kcal: Double
    @NSManaged public var name: String?
    public var wrappedName: String {
        name ?? "Unknown name"
    }
    @NSManaged public var perserving: String?
    public var wrappedPerServing: String {
        perserving ?? "Unknown serving content"
    }
    @NSManaged public var protein: Double
    @NSManaged public var serving: String?
    public var wrappedServing: String {
        serving ?? "Unknown serving type"
    }
    @NSManaged public var size: Double
    @NSManaged public var wasDeleted: Bool
    @NSManaged public var isFromDatabase: Bool
    @NSManaged public var foodentry: NSSet?
//    public var repastArray: [Repast] {
//        let entries = foodentry as? Set<FoodEntry> ?? []
//        let repasts = entries.compactMap { $0.repast }
//        return repasts.sorted {
//            if $0.wrappedType == $1.wrappedType {
//                return $0.date! < $1.date!
//            }
//            return $0.wrappedType < $1.wrappedType
//        }
//    }
}

// MARK: Generated accessors for foodentry
extension Food {

    @objc(addFoodentryObject:)
    @NSManaged public func addToFoodentry(_ value: FoodEntry)

    @objc(removeFoodentryObject:)
    @NSManaged public func removeFromFoodentry(_ value: FoodEntry)

    @objc(addFoodentry:)
    @NSManaged public func addToFoodentry(_ values: NSSet)

    @objc(removeFoodentry:)
    @NSManaged public func removeFromFoodentry(_ values: NSSet)

}

extension Food : Identifiable {

}
