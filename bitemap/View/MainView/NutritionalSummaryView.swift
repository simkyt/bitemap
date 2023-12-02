//
//  NutritionalSummaryView.swift
//  bitemap
//
//  Created by Simonas Kytra on 28/11/2023.
//

import SwiftUI

struct NutritionalSummaryView: View {
    @ObservedObject var contentViewModel: MainViewModel
    var bodyWidth: CGFloat

    init(contentViewModel: MainViewModel, bodyWidth: CGFloat) {
        self.contentViewModel = contentViewModel
        self.bodyWidth = bodyWidth
    }
    
    var body: some View {
        VStack {
            VStack {
                Text("\(NumberFormatter.customDecimalFormatter.string(from: contentViewModel.totalCalories))")
                    .font(.title.bold())
                    .scaleEffect(1.5)
                    .padding(5)
                    .animation(.interactiveSpring, value: contentViewModel.totalCalories)
                Text("calories eaten")
                    .font(.footnote)
            }
            .calorieCounterStyle()
            
            HStack {
                Spacer()
                VStack {
                    Text("Carbs")
                        .font(.footnote)
                        .overlay(Rectangle().frame(height: 1.5).foregroundColor(.orange), alignment: .bottom)
                    Text("\(NumberFormatter.customDecimalFormatter.string(from: contentViewModel.totalCarbs)) g")
                        .bold()
                        .animation(.interactiveSpring, value: contentViewModel.totalCarbs)
                }
                Spacer()
                VStack {
                    Text("Protein")
                        .font(.footnote)
                        .overlay(Rectangle().frame(height: 1.5).foregroundColor(.green), alignment: .bottom)
                    Text("\(NumberFormatter.customDecimalFormatter.string(from: contentViewModel.totalProtein)) g")
                        .bold()
                        .animation(.interactiveSpring, value: contentViewModel.totalProtein)
                }
                Spacer()
                VStack {
                    Text("Fat")
                        .font(.footnote)
                        .overlay(Rectangle().frame(height: 1.5).foregroundColor(.pink), alignment: .bottom)
                    Text("\(NumberFormatter.customDecimalFormatter.string(from: contentViewModel.totalFat)) g")
                        .bold()
                        .animation(.interactiveSpring, value: contentViewModel.totalFat)
                }
                Spacer()
            }
            .barStyle(width: bodyWidth)
            .padding(.horizontal, 20)
        }
    }
}

