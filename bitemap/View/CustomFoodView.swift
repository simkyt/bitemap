//
//  FoodView.swift
//  bitemap
//
//  Created by Simonas Kytra on 2023-08-30.
//

import SwiftUI
import CoreData

struct CustomFoodView: View {
    private var moc: NSManagedObjectContext
    @StateObject private var viewModel: CustomFoodViewModel
    
    @State private var showingAddScreen = false
    @State private var showDeletionAlert = false
    @State private var deletionIndexSet: IndexSet?
    
    @State private var selectedFood: Food?
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
        _viewModel = StateObject(wrappedValue: CustomFoodViewModel(moc: moc))
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Color.softerWhite
                    .edgesIgnoringSafeArea(.top)
                    .frame(height: geometry.size.width * 0.01)
                
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(.gray)
                
                if (viewModel.foods.isEmpty) {
                    Text("NO CUSTOM FOOD CREATED YET...")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.footnote)
                        .padding(.leading, 30)
                        .padding(.top, 20)
                } else {
                    Text("YOUR CUSTOM FOOD")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.footnote)
                        .padding(.leading, 30)
                        .padding(.top, 20)
                }
                
                List() {
                    ForEach(viewModel.foods) { food in
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
        }
        .background(
            Color.cream
                .edgesIgnoringSafeArea(.all)
        )
        .navigationTitle("Custom Food")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddScreen) {
            FoodDetailView(moc: moc)
                .onDisappear {
                    viewModel.fetchFoods()
                }
        }
        .sheet(item: $selectedFood) { food in
            FoodDetailView(moc: moc, food: food)
                .onDisappear {
                    viewModel.fetchFoods()
                }
        }
        .alert(isPresented: $showDeletionAlert) {
            Alert(
                title: Text("Delete Food"),
                message: Text("Are you sure you want to delete this food item?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let indexSet = deletionIndexSet {
                        viewModel.removeFood(at: indexSet)
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

//struct FoodView_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodView()
//    }
//}
