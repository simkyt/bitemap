//
//  SearchResultsView.swift
//  bitemap
//
//  Created by Simonas Kytra on 28/11/2023.
//

import SwiftUI

struct SearchResultsView: View {
    @Binding var search: String
    @Binding var searchEnabled: Bool
    @ObservedObject var viewModel: RepastViewModel
    var geometry: GeometryProxy
    var type: String
    var date: Date
    
    var body: some View {
        ScrollView {
            LazyVStack {
                FilteredList(
                    filters: [Filter(predicate: { NSPredicate(format: "name CONTAINS[c] %@ AND wasDeleted == %@ AND isFromDatabase == %@", search, NSNumber(value: false), NSNumber(value: false)) })],
                    sorts: []
                ) { (food: Food) in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(food.wrappedName)
                                .font(.headline)
                                .padding(.bottom, 0.5)
                            Text("\(NumberFormatter.customDecimalFormatter.string(from: food.kcal as NSNumber) ?? "0") kcal")
                                .font(.subheadline)
                            Text("1 \(food.wrappedServing) (\(NumberFormatter.customDecimalFormatter.string(from: food.size as NSNumber) ?? "0") \(food.wrappedPerServing)) ")
                                .font(.subheadline)
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

                if !viewModel.DBfoods.isEmpty {
                    Text("BITEMAP DATABASE RESULTS")
                        .font(.footnote)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 30)
                        .padding(.top, 10)
                }
                ForEach(viewModel.DBfoods, id: \.id) { dbFood in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(dbFood.name)
                                .font(.headline)
                                .padding(.bottom, 0.5)
                            if let brand = dbFood.brand, brand != "" {
                                Text(brand)
                                    .font(.subheadline)
                            }
                            Text("\(NumberFormatter.customDecimalFormatter.string(from: dbFood.kcal)) kcal")
                                .font(.subheadline)
                            Text("1 \(dbFood.serving) (\(NumberFormatter.customDecimalFormatter.string(from: dbFood.size)) \(dbFood.perserving)) ")
                                .font(.subheadline)
                        }
                        Spacer()
                        
                        Button {
                            viewModel.addDBFood(type: type, date: date, dbFood: dbFood)
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

                if !viewModel.FSfoods.isEmpty {
                    Text("FATSECRET DATABASE RESULTS")
                        .font(.footnote)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 30)
                        .padding(.top, 10)
                }
                ForEach(viewModel.FSfoods, id: \.id) { fsFood in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(fsFood.name)
                                .font(.headline)
                                .padding(.bottom, 0.5)
                            if let brand = fsFood.brand {
                                Text(brand)
                                    .font(.subheadline)
                            }
                            Text("\(NumberFormatter.customDecimalFormatter.string(from: fsFood.kcal)) kcal")
                                .font(.subheadline)
                            Text("1 \(fsFood.serving) (\(NumberFormatter.customDecimalFormatter.string(from: fsFood.size)) \(fsFood.perserving)) ")
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        Button {
                            viewModel.addFSFood(type: type, date: date, fsFood: fsFood)
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
