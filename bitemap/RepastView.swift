//
//  RepastView.swift
//  bitemap
//
//  Created by Simonas Kytra on 2023-09-09.
//

import SwiftUI
import CoreData

struct RepastView: View {
    @Environment(\.managedObjectContext) var moc
    @StateObject private var viewModel: RepastViewModel
    let type: String
    let date: Date
    @State private var search = ""
    @State private var searchEnabled = false
    
    init(type: String, date: Date, moc: NSManagedObjectContext) {
        self.type = type
        self.date = date
        _viewModel = StateObject(wrappedValue: RepastViewModel(moc: moc))
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    TextField("Food", text: $search, onEditingChanged: { changed in
                        if changed {
                            searchEnabled = true
                        } else {
                            searchEnabled = false
                            DispatchQueue.main.async { // does not work without being async
                                self.search = ""
                            }
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    })
                    .frame(width: geometry.size.width / 1.4)
                    .padding(7)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .padding([.top, .bottom, .leading], 5)
                    
                    Spacer()
                    
                    if searchEnabled {
                        Button(action: {
                            searchEnabled = false
                            search = ""
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }) {
                            Text("Cancel")
                                .font(.subheadline)
                                .padding(.trailing, 5)
                        }
                    }
                }
                .padding(.horizontal, 15)
                
                if searchEnabled {
                    FilteredList(
                        filters: [
                            Filter(predicate: { NSPredicate(format: "name CONTAINS[c] %@", search) })
                        ],
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
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                } else {
                    VStack {
                        HStack {
                            Text("Tracked")
                            Spacer()
                            Text("\(NumberFormatter.customDecimalFormatter.string(from: viewModel.repast?.kcal)) kcal")
                        }
                        HStack {
                            VStack {
                                Text("Carbs")
                                Text("\(NumberFormatter.customDecimalFormatter.string(from: viewModel.repast?.carbs)) g")
                            }
                            Spacer()
                            VStack {
                                Text("Protein")
                                Text("\(NumberFormatter.customDecimalFormatter.string(from: viewModel.repast?.protein)) g")
                            }
                            Spacer()
                            VStack {
                                Text("Fat")
                                Text("\(NumberFormatter.customDecimalFormatter.string(from: viewModel.repast?.fat)) g")
                            }
                        }
                        .padding(.top, 4)
                    }
                    .padding(.horizontal, 20)
                    .padding([.top, .bottom], 10)
                        
                    if let foodEntries = viewModel.repast?.foodEntryArray, foodEntries.count > 0 {
                        Text("You have tracked")
                        List() {
                            ForEach(foodEntries) { foodEntry in
                                VStack(alignment: .leading) {
                                    Text(foodEntry.food!.wrappedName)
                                        .font(.headline)
                                        .padding(.bottom, 0.5)
                                    Text("\(NumberFormatter.customDecimalFormatter.string(from: foodEntry.kcal)) kcal")
                                        .font(.subheadline)
                                    Text("1 \(foodEntry.food!.wrappedServing) (\(NumberFormatter.customDecimalFormatter.string(from: foodEntry.servingsize)) \(foodEntry.food!.wrappedPerServing)) ")
                                        .font(.subheadline)
                                }
                                .padding(.bottom, 5)
                            }
                            .onDelete { indexSet in
                                viewModel.removeFoodEntry(at: indexSet)
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .padding(.horizontal, 20)
                    } else {
                        VStack {
                            Spacer()
                            Text("You haven't tracked any food")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle(type)
            .navigationBarTitleDisplayMode(.inline)
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
