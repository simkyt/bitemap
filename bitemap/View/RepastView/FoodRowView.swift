//
//  FoodRowView.swift
//  bitemap
//
//  Created by Simonas Kytra on 01/12/2023.
//

import Foundation
import SwiftUI
import CoreData

struct FoodRowView: View {
    var foodEntry: FoodEntry
    var moc: NSManagedObjectContext
    @Binding var search: String
    @Binding var searchEnabled: Bool

    var body: some View {
        if let food = foodEntry.food {
            NavigationLink(destination: TrackedFoodDetailView(moc: moc, foodEntry: foodEntry, trackingType: .update, search: $search, searchEnabled: $searchEnabled)) {
                VStack(alignment: .leading) {
                    Text(food.wrappedName)
                        .font(.headline)
                        .padding(.bottom, 0.5)
                    Text("\(NumberFormatter.customDecimalFormatter.string(from: foodEntry.kcal)) kcal")
                        .font(.subheadline)
                    HStack {
                        Image(systemName: "rectangle.and.pencil.and.ellipsis")
                            .foregroundStyle(.black)
                        Text("\(NumberFormatter.customDecimalFormatter.string(from: foodEntry.servingsize)) \(foodEntry.wrappedServingUnit)")
                            .font(.subheadline)
                    }
                }
            }
            .listRowBackground(Color.softerWhite)
        }
    }
}
