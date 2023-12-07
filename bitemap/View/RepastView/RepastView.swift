//
//  RepastView.swift
//  bitemap
//
//  Created by Simonas Kytra on 2023-09-09.
//

import SwiftUI
import CoreData

struct RepastView: View {
    private var moc: NSManagedObjectContext
    @StateObject private var viewModel: RepastViewModel
    let type: String
    let date: Date
    
    @FocusState private var isFocused: Bool
    @State private var search = ""
    @State private var searchEnabled = false
    @State private var showAddScreen = false
    @State private var showQuickTrack = false
    
    init(type: String, date: Date, moc: NSManagedObjectContext) {
        self.type = type
        self.date = date
        self.moc = moc
        _viewModel = StateObject(wrappedValue: RepastViewModel(moc: moc))
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
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
                                    search = ""
                                }
                            })
                            .submitLabel(.search)
                            .focused($isFocused)
                            .onTapGesture {
                                isFocused = true
                            }
                            .onChange(of: search) { newValue in
                                viewModel.startSearch(searchText: newValue)
                            }
                        }
                        .foodSearchBarStyle(width: geometry.size.width)
                        .padding(.leading, 15)
                        
                        Spacer()
                        
                        if searchEnabled {
                            Button(action: {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                searchEnabled = false
                                search = ""
                            }) {
                                Text("Cancel")
                                    .foregroundStyle(Color.black)
                                    .font(.subheadline)
                                    .padding(.trailing, 16)
                            }
                        } else {
                            Menu {
                                Button {
                                    self.showQuickTrack = true
                                } label: {
                                    HStack {
                                        Text("Quick track")
                                        
                                        Image(systemName: "flame")
                                            .foregroundStyle(.black)
                                    }
                                }
                                Button {
                                    self.showAddScreen = true
                                } label: {
                                    HStack {
                                        Text("Create food")
                                        
                                        Image(systemName: "plus")
                                            .foregroundStyle(.black)
                                    }
                                }
                            } label: {
                                Text("...")
                                    .foregroundStyle(.black)
                                    .bold()
                            }
                            .foregroundStyle(Color.black)
                            .font(.title)
                            .padding(.trailing, 26)
                        }
                    }
                }
                
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(.gray)
                
                if searchEnabled {
                    SearchResultsView(search: $search,
                                      searchEnabled: $searchEnabled,
                                      viewModel: viewModel,
                                      geometry: geometry,
                                      type: type,
                                      date: date)
                } else {
                    NutritionBarView(repast: viewModel.repast, geometry: geometry)
                    
                    if viewModel.hasFoodEntries {
                        Text("YOU HAVE TRACKED")
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 30)
                        List() {
                            ForEach(viewModel.repast!.foodEntryArray) { foodEntry in
                                if let food = foodEntry.food {
                                    NavigationLink(destination: TrackedFoodDetailView(moc: moc, foodEntry: foodEntry, trackingType: .update, search: $search, searchEnabled: $searchEnabled)) {
                                        VStack(alignment: .leading) {
                                            Text(food.wrappedName)
                                                .font(.headline)
                                                .padding(.bottom, 0.5)
                                            Text("\(NumberFormatter.customDecimalFormatter.string(from: foodEntry.kcal)) kcal")
                                                .font(.subheadline)
                                            HStack {
                                                Image(systemName: "rectangle.and.pencil.and.ellipsis")
                                                    .foregroundStyle(.black)
                                                Text("\(NumberFormatter.customDecimalFormatter.string(from: foodEntry.servingsize)) \(foodEntry.wrappedServingUnit)")
                                                    .font(.subheadline)
                                            }
                                        }
                                    }
                                    .listRowBackground(Color.softerWhite)
                                }
                                QuickTrackRowView(foodEntry: foodEntry)
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
            .sheet(isPresented: $showAddScreen) {
                FoodDetailView(moc: moc)
            }
            .sheet(isPresented: $showQuickTrack) {
                QuickTrackView(moc: moc, type: type, date: date)
                    .onDisappear {
                        viewModel.loadRepast(for: type, date: date)
                    }
            }
        }
    }
}

//struct RepastView_Previews: PreviewProvider {
//    static var previews: some View {
//        RepastView()
//    }
//}
