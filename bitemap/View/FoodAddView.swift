//
//  FoodAddView.swift
//  bitemap
//
//  Created by Simonas Kytra on 2023-08-31.
//

import SwiftUI
import CoreData

struct FoodAddView: View {
    @Environment(\.managedObjectContext) var moc
    @StateObject private var viewModel: FoodAddViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showingError = false
    @State private var isPressed = false
    @State private var isMenuOpen = false
    @FocusState private var isFocused: Bool
    
    let servingTypes = ["Small serving", "Standard serving", "Large serving"]
    let servingContents = ["g", "ml"]
    
    init(moc: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: FoodAddViewModel(moc: moc))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        HStack {
                            Text("Name")
                                .frame(width: 50, alignment: .leading)
                            TextField("required", text: $viewModel.name)
                                .multilineTextAlignment(.trailing)
                        }
                        .formRowStyle()
                        
                        HStack {
                            Text("Brand")
                                .frame(width: 50, alignment: .leading)
                            TextField("optional", text: $viewModel.brand)
                                .multilineTextAlignment(.trailing)
                        }
                        .formRowStyle()
                        
                        HStack {
                            Text("Category")
                                .frame(width: 105, alignment: .leading)
                            Menu {
                                // Your existing ForEach and Button logic
                                ForEach(viewModel.categories, id: \.id) { category in
                                    Menu(category.name) {
                                        ForEach(viewModel.subcategories, id: \.id) { subcategory in
                                            if (subcategory.categoryID == category.id) {
                                                Button(subcategory.name) {
                                                    viewModel.category = subcategory.name
                                                    viewModel.categoryID = category.id
                                                    viewModel.subcategoryID = subcategory.id
                                                    isMenuOpen = false
                                                }
                                            }
                                        }
                                    }
                                }
                            } label: {
                                // This HStack composes the label for the Menu
                                HStack {
                                    Text(viewModel.category.isEmpty ? "required" : viewModel.category)
                                        .foregroundColor(.secondary)
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.secondary)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .onDisappear {
                                isMenuOpen = false
                            }
                        }
                        .formRowStyle()
                    } header: {
                        Text("Basic information")
                    }
                    
                    Section {
                        Picker("Serving type", selection: $viewModel.serving) {
                            ForEach(0..<servingTypes.count) {
                                Text(self.servingTypes[$0])
                            }
                            .pickerStyle(WheelPickerStyle())
                        }
                        .formRowStyle()
                        
                        Picker("Serving content", selection: $viewModel.perserving) {
                            ForEach(0..<servingContents.count) {
                                Text(self.servingContents[$0])
                            }
                            .pickerStyle(WheelPickerStyle())
                        }
                        .formRowStyle()
                        
                        HStack {
                            Text("1 serving has")
                            Spacer()
                            TextField(" ", text: $viewModel.size)
                                .frame(width: 60, height: 35)
                                .keyboardType(.decimalPad)
                                .border(Color.gray, width: 1)
                                .focused($isFocused)
                                .onTapGesture {
                                    isFocused = true
                                }
                            Text(servingContents[viewModel.perserving])
                        }
                        .formRowStyle()
                    } header: {
                        Text("Serving information")
                    }
                    
                    Section {
                        HStack {
                            Text("Kcal / 100 \(servingContents[viewModel.perserving])")
                                .frame(width: 100, alignment: .leading)
                            TextField("required", text: $viewModel.kcal)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                        }
                        .formRowStyle()
                        
                        HStack {
                            Text("Protein / 100 \(servingContents[viewModel.perserving])")
                                .frame(width: 120, alignment: .leading)
                            TextField("required", text: $viewModel.protein)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                        }
                        .formRowStyle()
                        
                        HStack {
                            Text("Carbs / 100 \(servingContents[viewModel.perserving])")
                                .frame(width: 110, alignment: .leading)
                            TextField("required", text: $viewModel.carbs)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                        }
                        .formRowStyle()
                        
                        HStack {
                            Text("Fat / 100 \(servingContents[viewModel.perserving])")
                                .frame(width: 90, alignment: .leading)
                            TextField("required", text: $viewModel.fat)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                        }
                        .formRowStyle()
                    } header: {
                        Text("Nutritional information")
                    }
                    
                    Section {
                        HStack {
                            Spacer()
                            Button(action: {
                                if viewModel.isValid() {
                                    viewModel.addFood()
                                    dismiss()
                                } else {
                                    showingError = true
                                }
                            }) {
                                Text("Add")
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
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .blur(radius: isMenuOpen ? 3 : 0)
            .navigationTitle("Create food")
            .navigationBarTitleDisplayMode(.inline)
            .background(
                Color.cream
                    .edgesIgnoringSafeArea(.all)
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color.black)
                    }
                }
            }
            .alert("Information not filled out", isPresented: $showingError) {
                Button("OK") {
                    showingError = false
                }
            } message: {
                Text("Please fill out the required information")
            }
        }
        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer) // this is for keyboard hiding when pressing somewhere on the view
    }
}

//struct FoodAddView_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodAddView()
//    }
//}
