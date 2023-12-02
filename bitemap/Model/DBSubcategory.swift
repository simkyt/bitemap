//
//  DBSubcategory.swift
//  bitemap
//
//  Created by Simonas Kytra on 28/11/2023.
//

import Foundation
import SwiftUI

struct DBSubcategory: Codable, Hashable {
    let categoryID: Int
    let description: String
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case categoryID = "category_id"
        case description, id, name
    }
}
