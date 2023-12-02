//
//  ContentView.swift
//  bitemap
//
//  Created by Simonas Kytra on 2023-08-29.
//

import SwiftUI
import CoreData

struct MainView: View {
    private var moc: NSManagedObjectContext
    @State var selectedDate: Date
    @StateObject var mainViewModel: MainViewModel
    
    init(moc: NSManagedObjectContext) {
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: now)
        let adjustedDate = calendar.date(from: components) ?? now

        self.moc = moc
        _selectedDate = State(initialValue: adjustedDate)
        _mainViewModel = StateObject(wrappedValue: MainViewModel(moc: moc, date: adjustedDate))
    }

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
        
                    Color.softerWhite
                        .edgesIgnoringSafeArea(.top)
                        .frame(height: geometry.size.height * 0.32)
                        .overlay(
                            NutritionalSummaryView(contentViewModel: mainViewModel, bodyWidth: geometry.size.width)
                        )
                                    
                    HStack {
                        Button {
                            selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!
                        } label: {
                            Image(systemName: "lessthan")
                                .foregroundStyle(Color.black)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        DatePicker("", selection: $selectedDate, displayedComponents: .date)
                            .scaleEffect(1.1)
                            .clipped()
                            .labelsHidden()
                            .background(Color.softerWhite.opacity(0.05))
                            .tint(Color.black)
                        
                        Button {
                            selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)!
                        } label: {
                            Image(systemName: "greaterthan")
                                .foregroundStyle(Color.black)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(width: geometry.size.width)
                    .padding([.top, .bottom], 20)
                    
                    Spacer()
                    
                    VStack {
                        RepastLinkView(moc: moc, repastType: "breakfast", calorieCount: mainViewModel.breakfastCalories, date: selectedDate, bodyWidth: geometry.size.width)
                        RepastLinkView(moc: moc, repastType: "lunch", calorieCount: mainViewModel.lunchCalories, date: selectedDate, bodyWidth: geometry.size.width)
                        RepastLinkView(moc: moc, repastType: "dinner", calorieCount: mainViewModel.dinnerCalories, date: selectedDate, bodyWidth: geometry.size.width)
                    }
                    .id(selectedDate)
                    .transition(.customSlide)
                    .animation(.easeInOut, value: selectedDate)
                    
                    Spacer()
                    
                    VStack {
                        HStack {
                            NavigationLink {
                                
                            } label: {
                                Text("Meals")
                                    .font(.headline)
                                    .mealsFoodStyle(width: geometry.size.width)
                            }
                            .padding(.top, 5)
                            
                            NavigationLink {
                                FoodView(moc: moc)
                            } label: {
                                Text("Food")
                                    .font(.headline)
                                    .mealsFoodStyle(width: geometry.size.width)
                            }
                            .padding(.top, 5)
                        }
                    }
                    
                    Spacer()
                }
                .navigationTitle("bitemap")
                .navigationBarTitleDisplayMode(.inline)
                .background(
                    Color.cream
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                )
                .onAppear {
                    mainViewModel.calculateTotalCalories(for: selectedDate)
                }
                .onChange(of: selectedDate) { newDate in
                    mainViewModel.calculateTotalCalories(for: newDate)
                }
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
