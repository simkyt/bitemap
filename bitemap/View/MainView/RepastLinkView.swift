//
//  RepastLinkView.swift
//  bitemap
//
//  Created by Simonas Kytra on 28/11/2023.
//

import SwiftUI
import CoreData

struct RepastLinkView: View {
    private let repastType: String
    private let calorieCount: Double
    private let date: Date
    private var moc: NSManagedObjectContext
    private var bodyWidth: CGFloat

    init(moc: NSManagedObjectContext, repastType: String, calorieCount: Double, date: Date, bodyWidth: CGFloat) {
        self.moc = moc
        self.repastType = repastType
        self.calorieCount = calorieCount
        self.date = date
        self.bodyWidth = bodyWidth
    }
    
    var body: some View {
        NavigationLink {
            RepastView(type: repastType, date: date, moc: moc)
        } label: {
            HStack {
                Image(repastType)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 35)
                    .padding(.leading, 20)
                Text(repastType)
                    .padding(.leading, 10)
                Spacer()
                VStack {
                    Spacer()
                    Text(String(format: "%.0f kcal", calorieCount))
                        .font(.footnote)
                        .padding([.trailing, .bottom], 12)
                }
            }
            .barStyle(width: bodyWidth)
        }
        .padding([.leading, .trailing], 10)
    }
}
