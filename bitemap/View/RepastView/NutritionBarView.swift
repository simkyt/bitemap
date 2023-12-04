//
//  NutritionBarView.swift
//  bitemap
//
//  Created by Simonas Kytra on 02/12/2023.
//

import Foundation
import SwiftUI

struct NutritionTrackView: View {
    let repast: Repast?
    let geometry: GeometryProxy

    var body: some View {
        VStack {
            HStack {
                Text("Tracked")
                    .font(.footnote)
                Spacer()
                Text("\(NumberFormatter.customDecimalFormatter.string(from: repast?.kcal)) kcal")
                    .bold()
            }
            HStack {
                VStack {
                    Text("Carbs")
                        .font(.footnote)
                        .overlay(Rectangle().frame(height: 1.5).foregroundColor(.orange), alignment: .bottom)
                    Text("\(NumberFormatter.customDecimalFormatter.string(from: repast?.carbs)) g")
                        .bold()
                }
                Spacer()
                VStack {
                    Text("Protein")
                        .font(.footnote)
                        .overlay(Rectangle().frame(height: 1.5).foregroundColor(.green), alignment: .bottom)
                    Text("\(NumberFormatter.customDecimalFormatter.string(from: repast?.protein)) g")
                        .bold()
                }
                Spacer()
                VStack {
                    Text("Fat")
                        .font(.footnote)
                        .overlay(Rectangle().frame(height: 1.5).foregroundColor(.pink), alignment: .bottom)
                    Text("\(NumberFormatter.customDecimalFormatter.string(from: repast?.fat)) g")
                        .bold()
                }
            }
            .padding(.top, 4)
        }
        .repastTrackBarStyle(width: geometry.size.width)
        .padding(.bottom, 5)
    }
}
