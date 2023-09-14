//
//  FoodView.swift
//  bitemap
//
//  Created by Simonas Kytra on 2023-08-30.
//

import SwiftUI
import CoreData

struct FoodView: View {
    @State private var showingAddScreen = false
    @Environment(\.managedObjectContext) var moc
    @StateObject private var viewModel: FoodViewModel
    @FetchRequest(sortDescriptors: []) var foods: FetchedResults<Food>
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        return formatter
    }()
    
    init(moc: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: FoodViewModel(moc: moc))
    }
    
    var body: some View {
        VStack {
            List() {
                ForEach(foods) { food in
                    VStack(alignment: .leading) {
                        Text(food.wrappedName)
                            .font(.headline)
                            .padding(.bottom, 0.5)
                        Text("\(formatter.string(from: food.kcal as NSNumber) ?? "0") kcal")
                            .font(.subheadline)
                        Text("1 \(food.wrappedServing) (\(formatter.string(from: food.size as NSNumber) ?? "0") \(food.wrappedPerServing)) ")
                            .font(.subheadline)
                    }
                }
                .onDelete { indexSet in
                    viewModel.removeFood(from: foods, at: indexSet)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .sheet(isPresented: $showingAddScreen) {
            FoodAddView(moc: moc)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddScreen = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

//struct FoodView_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodView()
//    }
//}
