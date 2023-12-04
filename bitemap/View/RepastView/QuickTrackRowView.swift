//
//  QuickTrackRowView.swift
//  bitemap
//
//  Created by Simonas Kytra on 01/12/2023.
//

import Foundation
import SwiftUI

struct QuickTrackRowView: View {
    var foodEntry: FoodEntry
    
    var body: some View {
        if let quickTrack = foodEntry.quicktrack {
            VStack(alignment: .leading) {
                Text(quickTrack.wrappedName)
                    .font(.headline)
                    .padding(.bottom, 0.5)
                HStack {
                    Text("\(NumberFormatter.customDecimalFormatter.string(from: foodEntry.carbs))g carbs")
                        .font(.footnote)
                    Text("\(NumberFormatter.customDecimalFormatter.string(from: foodEntry.protein))g protein")
                        .font(.footnote)
                    Text("\(NumberFormatter.customDecimalFormatter.string(from: foodEntry.fat))g fat")
                        .font(.footnote)
                }
                HStack {
                    Image(systemName: "flame")
                        .foregroundStyle(Color.black)
                    Text("\(NumberFormatter.customDecimalFormatter.string(from: foodEntry.servingsize)) \(foodEntry.wrappedServingUnit)")
                        .font(.subheadline)
                }
            }
            .listRowBackground(Color.softerWhite)
        }
    }
}
