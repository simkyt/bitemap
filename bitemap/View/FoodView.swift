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
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "wasDeleted == %@ AND isFromDatabase == %@", NSNumber(value: false), NSNumber(value: false))) var foods: FetchedResults<Food>
    @State private var showDeletionAlert = false
    @State private var deletionIndexSet: IndexSet?
    
    @State private var selectedFood: Food?
    
    init(moc: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: FoodViewModel(moc: moc))
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    Color.softerWhite
                        .edgesIgnoringSafeArea(.top)
                        .frame(height: geometry.size.width * 0.1)
                    
                    
                    if (foods.isEmpty) {
                        VStack {
                            Text("NO CUSTOM FOOD CREATED YET...")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.footnote)
                                .padding(.leading, 30)
                        }
                    } else {
                        Text("YOUR CUSTOM FOOD")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.footnote)
                            .padding(.leading, 30)
                    }
                }
                List() {
                    ForEach(foods) { food in
                        Button(action: {
                            self.selectedFood = food
                        }) {
                            VStack(alignment: .leading) {
                                Text(food.wrappedName)
                                    .font(.headline)
                                    .padding(.bottom, 0.5)
                                Text("\(NumberFormatter.customDecimalFormatter.string(from: food.kcal as NSNumber) ?? "0") kcal")
                                    .font(.subheadline)
                                Text("1 \(food.wrappedServing) (\(NumberFormatter.customDecimalFormatter.string(from: food.size as NSNumber) ?? "0") \(food.wrappedPerServing)) ")
                                    .font(.subheadline)
                            }
                            .foregroundStyle(.black)
                        }
                        .listRowBackground(Color.softerWhite)
                    }
                    .onDelete { indexSet in
                        deletionIndexSet = indexSet
                        showDeletionAlert = true
                    }
                }
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 20)
                .shadow(color: .gray, radius: 1, x: 0, y: 2)
            }
            .background(
                Color.cream
                    .edgesIgnoringSafeArea(.all)
            )
            .navigationTitle("Custom Food")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingAddScreen) {
                FoodAddView(moc: moc)
            }
            .sheet(item: $selectedFood) { food in
                EditCustomFoodView(moc: moc, food: food)
            }
            .alert(isPresented: $showDeletionAlert) {
                Alert(
                    title: Text("Delete Food"),
                    message: Text("Are you sure you want to delete this food item?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let indexSet = deletionIndexSet {
                            viewModel.removeFood(from: foods, at: indexSet)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddScreen = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(Color.black)
                    }
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
