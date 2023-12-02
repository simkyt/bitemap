//
//  RepastView.swift
//  bitemap
//
//  Created by Simonas Kytra on 2023-09-09.
//

import SwiftUI
import CoreData

struct RepastView: View {
//    @Environment(\.managedObjectContext) var moc
    private var moc: NSManagedObjectContext
    @StateObject private var viewModel: RepastViewModel
    let type: String
    let date: Date
    
    @FocusState private var isFocused: Bool
    @State private var search = ""
    @State private var searchEnabled = false
    
    init(type: String, date: Date, moc: NSManagedObjectContext) {
        self.type = type
        self.date = date
        self.moc = moc
        _viewModel = StateObject(wrappedValue: RepastViewModel(moc: moc))
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    Color.softerWhite
                        .edgesIgnoringSafeArea(.top)
                        .frame(height: geometry.size.width * 0.18)
                    
                    HStack {
                        HStack {
                            if (searchEnabled == false) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.black)
                            }
                            
                            TextField("Food", text: $search, onEditingChanged: { changed in
                                if changed {
                                    searchEnabled = true
                                }
                            })
                            .submitLabel(.search)
                            .focused($isFocused)
                            .onTapGesture {
                                isFocused = true
                            }
                            .onSubmit {
                                viewModel.fetchFoodsFromFS(searchText: search)
                            }
                            .onChange(of: search) { _ in
                                viewModel.fetchFoodsFromDatabase(searchText: search)
                            }
                        }
                        .foodSearchBarStyle(width: geometry.size.width)
                        .padding(.leading, 15)
                        
                        Spacer()
                        
                        if searchEnabled {
                            Button(action: {
                                searchEnabled = false
                                search = ""
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }) {
                                Text("Cancel")
                                    .foregroundStyle(Color.black)
                                    .font(.subheadline)
                                    .padding(.trailing, 16)
                            }
                        }
                    }
                }
                
                if searchEnabled {
                    SearchResultsView(search: $search,
                                      searchEnabled: $searchEnabled,
                                      viewModel: viewModel,
                                      geometry: geometry,
                                      type: type,
                                      date: date)
                } else {
                    VStack {
                        HStack {
                            Text("Tracked")
                                .font(.footnote)
                            Spacer()
                            Text("\(NumberFormatter.customDecimalFormatter.string(from: viewModel.repast?.kcal)) kcal")
                                .bold()
                        }
                        HStack {
                            VStack {
                                Text("Carbs")
                                    .font(.footnote)
                                    .overlay(Rectangle().frame(height: 1.5).foregroundColor(.orange), alignment: .bottom)
                                Text("\(NumberFormatter.customDecimalFormatter.string(from: viewModel.repast?.carbs)) g")
                                    .bold()
                            }
                            Spacer()
                            VStack {
                                Text("Protein")
                                    .font(.footnote)
                                    .overlay(Rectangle().frame(height: 1.5).foregroundColor(.green), alignment: .bottom)
                                Text("\(NumberFormatter.customDecimalFormatter.string(from: viewModel.repast?.protein)) g")
                                    .bold()
                            }
                            Spacer()
                            VStack {
                                Text("Fat")
                                    .font(.footnote)
                                    .overlay(Rectangle().frame(height: 1.5).foregroundColor(.pink), alignment: .bottom)
                                Text("\(NumberFormatter.customDecimalFormatter.string(from: viewModel.repast?.fat)) g")
                                    .bold()
                            }
                        }
                        .padding(.top, 4)
                    }
                    .repastTrackBarStyle(width: geometry.size.width)
                    
                    if let foodEntries = viewModel.repast?.foodEntryArray, foodEntries.count > 0 {
                        Text("YOU HAVE TRACKED")
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 30)
                        List() {
                            ForEach(foodEntries) { foodEntry in
                                if let food = foodEntry.food {
                                    NavigationLink(destination: TrackedFoodDetailView(moc: moc, foodEntry: foodEntry)) {
                                        VStack(alignment: .leading) {
                                            Text(food.wrappedName)
                                                .font(.headline)
                                                .padding(.bottom, 0.5)
                                            Text("\(NumberFormatter.customDecimalFormatter.string(from: foodEntry.kcal)) kcal")
                                                .font(.subheadline)
                                            Text("\(NumberFormatter.customDecimalFormatter.string(from: foodEntry.servingsize)) \(foodEntry.wrappedServingUnit)")
                                                .font(.subheadline)
                                        }
                                    }
                                    .listRowBackground(Color.softerWhite)
                                }
                            }
                            .onDelete { indexSet in
                                viewModel.removeFoodEntry(at: indexSet)
                            }                  
                        }
                        .scrollContentBackground(.hidden)
                        .padding(.horizontal, 20)
                        .shadow(color: .gray, radius: 1, x: 0, y: 2)
                    } else {
                        VStack {
                            Spacer()
                            Text("YOU HAVEN'T TRACKED ANY FOOD SO FAR...")
                                .font(.footnote)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle(type)
            .navigationBarTitleDisplayMode(.inline)
            .background(
                Color.cream
                    .edgesIgnoringSafeArea(.all)
            )
            .onAppear {
                viewModel.loadRepast(for: type, date: date)
            }
        }
    }
}

//struct RepastView_Previews: PreviewProvider {
//    static var previews: some View {
//        RepastView()
//    }
//}
