//
//  FatSecretFood.swift
//  bitemap
//
//  Created by Simonas Kytra on 28/11/2023.
//

import Foundation
import SwiftUI

// for FatSecret database
struct FS: Codable {
    let foods: FSFoods?
}

struct FSFoods: Codable {
    let food: [FSFood]?
//    let maxResults, pageNumber, totalResults: String

    enum CodingKeys: String, CodingKey {
        case food
//        case maxResults = "max_results"
//        case pageNumber = "page_number"
//        case totalResults = "total_results"
    }
}

struct FSFood: Codable, DBFood {
    let brand: String?
    let foodDescription, id, name: String
//    let foodType: FoodType
//    let foodURL: String

    enum CodingKeys: String, CodingKey {
        case brand = "brand_name"
        case foodDescription = "food_description"
        case id = "food_id"
        case name = "food_name"
//        case foodType = "food_type"
//        case foodURL = "food_url"
    }

    var size: Double {
        let regex = try! NSRegularExpression(pattern: "Per (\\d+)g")
        let descriptionRange = NSRange(foodDescription.startIndex..<foodDescription.endIndex, in: foodDescription)
        
        if let match = regex.firstMatch(in: foodDescription, options: [], range: descriptionRange),
           let range = Range(match.range(at: 1), in: foodDescription) {
            let numberString = String(foodDescription[range])
            return Double(numberString) ?? 0
        }
        
        return 0
    }


    var perserving: String {
        "g"
    }

    var kcal: Double {
        extractNutrientValue(for: "Calories: ", endingWith: "kcal")
    }

    var fat: Double {
        extractNutrientValue(for: "Fat: ", endingWith: "g")
    }

    var carbs: Double {
        extractNutrientValue(for: "Carbs: ", endingWith: "g")
    }

    var protein: Double {
        extractNutrientValue(for: "Protein: ", endingWith: "g")
    }
    
    var serving: String = "Standard serving"

    private func extractNutrientValue(for nutrient: String, endingWith suffix: String) -> Double {
        guard let range = foodDescription.range(of: nutrient),
              let endRange = foodDescription.range(of: suffix, range: range.upperBound..<foodDescription.endIndex) else {
            return 0
        }

        let start = range.upperBound
        let end = endRange.lowerBound
        let valueString = String(foodDescription[start..<end])

        return Double(valueString.trimmingCharacters(in: .whitespaces)) ?? 0
    }
}


//enum FoodType: String, Codable {
//    case brand = "Brand"
//    case generic = "Generic"
//}
