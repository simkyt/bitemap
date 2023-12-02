//
//  Food.swift
//  bitemap
//
//  Created by Simonas Kytra on 27/11/2023.
//

import Foundation
import SwiftUI

struct DBFood: Codable, StandardFood {
    let brand: String?
    let carbs: Double
    let fat: Double
    let id: String
    let kcal: Double
    let name, perserving: String
    let protein: Double
    let serving: String
    let size: Double
    let subcategoryID: Int

    enum CodingKeys: String, CodingKey {
        case brand, carbs, fat, id, kcal, name, perserving, protein, serving, size
        case subcategoryID = "subcategory_id"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(brand, forKey: .brand)
        try container.encode(carbs, forKey: .carbs)
        try container.encode(fat, forKey: .fat)
        try container.encode(kcal, forKey: .kcal)
        try container.encode(name, forKey: .name)
        try container.encode(perserving, forKey: .perserving)
        try container.encode(protein, forKey: .protein)
        try container.encode(serving, forKey: .serving)
        try container.encode(size, forKey: .size)
        try container.encode(subcategoryID, forKey: .subcategoryID)
    }
}
