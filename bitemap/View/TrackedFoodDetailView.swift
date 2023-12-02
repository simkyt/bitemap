//
//  TrackedFoodDetailView.swift
//  bitemap
//
//  Created by Simonas Kytra on 29/11/2023.
//

import Foundation
import SwiftUI
import CoreData

struct TrackedFoodDetailView: View {
    var moc: NSManagedObjectContext
    @StateObject private var viewModel: TrackedFoodDetailViewModel
    
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var isFocused: Bool
    let maxLength = 4
    
    init(moc: NSManagedObjectContext, foodEntry: FoodEntry) {
        self.moc = moc
        _viewModel = StateObject(wrappedValue: TrackedFoodDetailViewModel(moc: moc, foodEntry: foodEntry))
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                ZStack {
                    Color.softerWhite
                        .edgesIgnoringSafeArea(.top)
                        .frame(height: geometry.size.width * 0.2)
                    HStack {
                        TextField(viewModel.servingSizeText, text: $viewModel.servingSizeText)
                            .keyboardType(.decimalPad)
                            .onChange(of: viewModel.servingSizeText) { newValue in
                                if newValue.count > maxLength {
                                    viewModel.servingSizeText = String(newValue.prefix(maxLength))
                                }
                                viewModel.updateTemporaryValues()
                            }
                            .servingSizeBarStyle(width: geometry.size.width)
                            .focused($isFocused)
                            .onTapGesture {
                                isFocused = true
                            }
                            .multilineTextAlignment(.center)
                        Spacer()
                        
                        Menu {
                            Button {
                                viewModel.temporaryServingUnit = "\(viewModel.foodEntry.food!.wrappedServing) (\(NumberFormatter.customDecimalFormatter.string(from: viewModel.foodEntry.food!.size)) \(viewModel.foodEntry.food!.wrappedPerServing))"
                            } label: {
                                Text("\(viewModel.foodEntry.food!.wrappedServing) (\(NumberFormatter.customDecimalFormatter.string(from: viewModel.foodEntry.food!.size)) \(viewModel.foodEntry.food!.wrappedPerServing))")
                            }
                            
                            Button {
                                viewModel.temporaryServingUnit = "Grams"
                            } label: {
                                Text("Grams")
                            }
                            
                        } label: {
                            Text("\(viewModel.temporaryServingUnit)")
                                .servingUnitBarStyle(width: geometry.size.width)
                        }
                        .onChange(of: viewModel.temporaryServingUnit) { _ in
                            viewModel.updateTemporaryValues()
                        }
                        .foregroundStyle(Color.black)
                    }
                }
                
                Spacer()
                
                Text("NUTRITIONAL INFORMATION")
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 30)
                
                VStack {
                    HStack {
                        Text("Calories")
                            .bold()
                        Spacer()
                        Text("\(NumberFormatter.customDecimalFormatter.string(from: viewModel.temporaryKcal)) kcal")
                            .bold()
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Carbs")
                            .bold()
                            .overlay(Rectangle().frame(height: 1.5).foregroundColor(.orange), alignment: .bottom)
                        Spacer()
                        Text("\(NumberFormatter.customDecimalFormatter.string(from: viewModel.temporaryCarbs)) g")
                            .bold()
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Protein")
                            .bold()
                            .overlay(Rectangle().frame(height: 1.5).foregroundColor(.green), alignment: .bottom)
                        Spacer()
                        Text("\(NumberFormatter.customDecimalFormatter.string(from: viewModel.temporaryProtein)) g")
                            .bold()
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Fat")
                            .bold()
                            .overlay(Rectangle().frame(height: 1.5).foregroundColor(.pink), alignment: .bottom)
                        Spacer()
                        Text("\(NumberFormatter.customDecimalFormatter.string(from: viewModel.temporaryFat)) g")
                            .bold()
                    }
                }
                .repastTrackBarStyle(width: geometry.size.width)
                
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.saveChanges()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Update")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .frame(width: 150)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
                .listRowBackground(Color.clear)
                
                Spacer()
            }
            .navigationTitle(viewModel.foodEntry.food!.wrappedName)
            .background(
                Color.gray.opacity(0.05)
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            )
            .background(
                Color.cream
                    .edgesIgnoringSafeArea(.all)
            )
            .onTapGesture {
                self.hideKeyboard()
            }
        }
    }
    
    private func hideKeyboard() {
        if viewModel.servingSizeText == "" || viewModel.servingSizeText == "0" {
            viewModel.servingSizeText = NumberFormatter.customDecimalFormatter.string(from: viewModel.foodEntry.servingsize)
        }
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
