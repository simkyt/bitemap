//
//  SearchResultsView.swift
//  bitemap
//
//  Created by Simonas Kytra on 28/11/2023.
//

import SwiftUI
import CoreData

struct SearchResultsView: View {
    @Environment(\.managedObjectContext) var moc
//    private var moc: NSManagedObjectContext
    
    @Binding var search: String
    @Binding var searchEnabled: Bool
    
    @StateObject var viewModel: RepastViewModel
    @State private var selectedFoodEntry: FoodEntry?
    @State private var isNavigationActive = false

    var geometry: GeometryProxy
    var type: String
    var date: Date
    
//    init(moc: NSManagedObjectContext, search: Binding<String>, searchEnabled: Binding<Bool>, geometry: GeometryProxy, type: String, date: Date) {
//        self.moc = moc
//        self._search = search
//        self._searchEnabled = searchEnabled
//        self.geometry = geometry
//        self.type = type
//        self.date = date
//        _viewModel = StateObject(wrappedValue: RepastViewModel(moc: moc))
//    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                FilteredList(
                    filters: [Filter(predicate: { NSPredicate(format: "name CONTAINS[c] %@ AND wasDeleted == %@ AND isFromDatabase == %@", search, NSNumber(value: false), NSNumber(value: false)) })],
                    sorts: []
                ) { (food: Food) in
                    Button(action: {
                        selectedFoodEntry = viewModel.prepareFoodEntryAndRepast(type: type, date: date, food: food).foodEntry
                        isNavigationActive = true
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(food.wrappedName)
                                    .font(.headline)
                                    .padding(.bottom, 0.5)
                                Text("\(NumberFormatter.customDecimalFormatter.string(from: food.kcal as NSNumber) ?? "0") kcal")
                                    .font(.subheadline)
                                HStack {
                                    Image(systemName: "rectangle.and.pencil.and.ellipsis")
                                        .foregroundStyle(.black)
                                    Text("1 \(food.wrappedServing) (\(NumberFormatter.customDecimalFormatter.string(from: food.size as NSNumber) ?? "0") \(food.wrappedPerServing)) ")
                                        .font(.subheadline)
                                }
                            }
                            
                            Spacer()
                            
                            Button {
                                viewModel.addFood(type: type, date: date, food: food)
                                searchEnabled = false
                                search = ""
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            } label: {
                                Image(systemName: "plus")
                                    .foregroundStyle(Color.black)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        .foodBarStyle(width: geometry.size.width)
                    }
                }
                
                if !viewModel.combinedFoods.isEmpty {
                    Text("RESULTS")
                        .font(.footnote)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 30)
                        .padding(.top, 10)
                    
                    ForEach(viewModel.combinedFoods, id: \.id) { food in
                        Button(action: {
                            if let foodEntry = viewModel.createTemporaryFoodEntry(food: food, type: type, date: date) {
                                selectedFoodEntry = foodEntry
                                isNavigationActive = true
                            }
                        }) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(food.name)
                                        .multilineTextAlignment(.leading)
                                        .font(.headline)
                                        .padding(.bottom, 0.5)
                                    if let brand = food.brand, brand != "" {
                                        Text(brand)
                                            .font(.subheadline)
                                    }
                                    Text("\(NumberFormatter.customDecimalFormatter.string(from: food.kcal)) kcal")
                                        .font(.subheadline)
                                    HStack {
                                        Image(systemName: "rectangle.and.pencil.and.ellipsis")
                                            .foregroundStyle(.black)
                                        Text("1 \(food.serving) (\(NumberFormatter.customDecimalFormatter.string(from: food.size)) \(food.perserving)) ")
                                            .font(.subheadline)
                                    }
                                }
                                Spacer()
                                
                                Button {
                                    viewModel.addDatabaseFood(type: type, date: date, food: food)
                                    searchEnabled = false
                                    search = ""
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                } label: {
                                    Image(systemName: "plus")
                                        .foregroundStyle(Color.black)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            .foodBarStyle(width: geometry.size.width)
                        }
                    }
                }
            }
        }
        if let foodEntry = selectedFoodEntry {
            NavigationLink(
                destination: TrackedFoodDetailView(moc: moc, foodEntry: foodEntry, trackingType: .track, search: $search, searchEnabled: $searchEnabled),
                isActive: $isNavigationActive
            ) {
                EmptyView()
            }
        }
    }
}
