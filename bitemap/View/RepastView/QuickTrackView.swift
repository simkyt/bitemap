//
//  QuickTrackView.swift
//  bitemap
//
//  Created by Simonas Kytra on 01/12/2023.
//

import Foundation
import SwiftUI
import CoreData

struct QuickTrackView: View {
    private var moc: NSManagedObjectContext
    @StateObject private var viewModel: QuickTrackViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var showingError = false
    @State private var isPressed = false
    @FocusState private var isFocused: Bool
    
    init(moc: NSManagedObjectContext, type: String, date: Date) {
        self.moc = moc
        _viewModel = StateObject(wrappedValue: QuickTrackViewModel(moc: moc, type: type, date: date))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        HStack {
                            Text("Name")
                                .frame(width: 50, alignment: .leading)
                            TextField("optional", text: $viewModel.name)
                                .multilineTextAlignment(.trailing)
                        }
                        .formRowStyle()
                        
                        HStack {
                            Text("Kcal (g)")
                                .frame(width: 100, alignment: .leading)
                            TextField("required", text: $viewModel.kcal)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.numberPad)
                        }
                        .formRowStyle()
                        
                        HStack {
                            Text("Protein (g)")
                                .frame(width: 120, alignment: .leading)
                            TextField("optional", text: $viewModel.protein)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                        }
                        .formRowStyle()
                        
                        HStack {
                            Text("Carbs (g)")
                                .frame(width: 110, alignment: .leading)
                            TextField("optional", text: $viewModel.carbs)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                        }
                        .formRowStyle()
                        
                        HStack {
                            Text("Fat (g)")
                                .frame(width: 90, alignment: .leading)
                            TextField("optional", text: $viewModel.fat)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                        }
                        .formRowStyle()
                    } header: {
                        Text("Basic information")
                    }
                }
                .scrollContentBackground(.hidden)
                
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
                        Text("Track")
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
                .padding(.bottom, 16)
            }
            .navigationTitle("Quick track")
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
