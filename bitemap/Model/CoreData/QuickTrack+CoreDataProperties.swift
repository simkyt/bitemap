//
//  QuickTrack+CoreDataProperties.swift
//  bitemap
//
//  Created by Simonas Kytra on 04/12/2023.
//
//

import Foundation
import CoreData


extension QuickTrack {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuickTrack> {
        return NSFetchRequest<QuickTrack>(entityName: "QuickTrack")
    }

    @NSManaged public var name: String?
    public var wrappedName: String {
        name ?? "Unknown name"
    }
    @NSManaged public var id: UUID?
    @NSManaged public var kcal: Double
    @NSManaged public var carbs: Double
    @NSManaged public var fat: Double
    @NSManaged public var protein: Double
    @NSManaged public var foodentry: NSSet?

}

// MARK: Generated accessors for foodentry
extension QuickTrack {

    @objc(addFoodentryObject:)
    @NSManaged public func addToFoodentry(_ value: FoodEntry)

    @objc(removeFoodentryObject:)
    @NSManaged public func removeFromFoodentry(_ value: FoodEntry)

    @objc(addFoodentry:)
    @NSManaged public func addToFoodentry(_ values: NSSet)

    @objc(removeFoodentry:)
    @NSManaged public func removeFromFoodentry(_ values: NSSet)

}

extension QuickTrack : Identifiable {

}
