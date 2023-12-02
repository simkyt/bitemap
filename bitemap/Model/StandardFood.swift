//
//  StandardFood.swift
//  bitemap
//
//  Created by Simonas Kytra on 02/12/2023.
//

import Foundation

protocol StandardFood {
    var id: String { get }
    var brand: String? { get }
    var carbs: Double { get }
    var fat: Double { get }
    var kcal: Double { get }
    var name: String { get }
    var perserving: String { get }
    var protein: Double { get }
    var serving: String { get }
    var size: Double { get }
}
