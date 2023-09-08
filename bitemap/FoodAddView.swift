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
                        
                        HStack {
                            Text("Brand")
                                .frame(width: 50, alignment: .leading)
                            TextField("optional", text: $viewModel.brand)
                                .multilineTextAlignment(.trailing)
                        }
                        // category needs to be done
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
                        
                        Picker("Serving content", selection: $viewModel.perserving) {
                            ForEach(0..<servingContents.count) {
                                Text(self.servingContents[$0])
                            }
                            .pickerStyle(WheelPickerStyle())
                        }
                        
                        HStack {
                            Text("1 serving has")
                            Spacer()
                            TextField(" ", text: $viewModel.size)
                                .frame(width: 60, height: 35)
                                .keyboardType(.decimalPad)
                                .border(Color.gray, width: 1)
                            Text(servingContents[viewModel.perserving])
                        }
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
                        
                        HStack {
                            Text("Protein / 100 \(servingContents[viewModel.perserving])")
                                .frame(width: 120, alignment: .leading)
                            TextField("required", text: $viewModel.protein)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                        }
                        
                        HStack {
                            Text("Carbs / 100 \(servingContents[viewModel.perserving])")
                                .frame(width: 110, alignment: .leading)
                            TextField("required", text: $viewModel.carbs)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                        }
                        
                        HStack {
                            Text("Fat / 100 \(servingContents[viewModel.perserving])")
                                .frame(width: 90, alignment: .leading)
                            TextField("required", text: $viewModel.fat)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                        }
                        
                    } header: {
                        Text("Nutritional information")
                    }
                }
                .scrollContentBackground(.hidden)
                
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
 //               .buttonStyle(PlainButtonStyle())
 //               .listRowBackground(Color.clear)
                
                Spacer()
                Spacer()
            }
            .navigationTitle("Create food")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Color.black)
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
    }
}

//struct FoodAddView_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodAddView()
//    }
//}
