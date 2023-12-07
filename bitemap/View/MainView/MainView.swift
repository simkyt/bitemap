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
    @State private var selectedDate: Date
    @StateObject private var mainViewModel: MainViewModel
    
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
                        .frame(height: 180)
                        .overlay(
                            NutritionalSummaryView(contentViewModel: mainViewModel, bodyWidth: geometry.size.width)
                        )
                    
                    Spacer()
                    
                    HStack {
                        Button {
                            selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!
                        } label: {
                            Image(systemName: "lessthan")
                                .foregroundStyle(Color.black)
                        }
                        .frame(maxWidth: 100, alignment: .center)
                        
                        ZStack {
                            Text(selectedDate.customFormatted())
                                .frame(maxWidth: .infinity)
                                .lineLimit(1)
                            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                .scaleEffect(1.1)
                                .clipped()
                                .labelsHidden()
                                .opacity(0.011)
                                .tint(Color.green)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button {
                            selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)!
                        } label: {
                            Image(systemName: "greaterthan")
                                .foregroundStyle(Color.black)
                        }
                        .frame(maxWidth: 100, alignment: .center)
                    }
                    .frame(width: geometry.size.width)
                    .padding([.top, .bottom], 20)
                    
                    Spacer()
                    
                    VStack {
                        RepastLinkView(moc: moc, repastType: "Breakfast", calorieCount: mainViewModel.breakfastCalories, date: selectedDate, bodyWidth: geometry.size.width)
                        RepastLinkView(moc: moc, repastType: "Lunch", calorieCount: mainViewModel.lunchCalories, date: selectedDate, bodyWidth: geometry.size.width)
                        RepastLinkView(moc: moc, repastType: "Dinner", calorieCount: mainViewModel.dinnerCalories, date: selectedDate, bodyWidth: geometry.size.width)
                        RepastLinkView(moc: moc, repastType: "Snacks", calorieCount: mainViewModel.snacksCalories, date: selectedDate, bodyWidth: geometry.size.width)
                    }
                    .id(selectedDate)
                    .transition(.customSlide)
                    .animation(.easeInOut, value: selectedDate)
                    
                    Spacer()
                    
                    
                    HStack {
                        Spacer()
                        Spacer()
                        NavigationLink {
                            CustomFoodView(moc: moc)
                        } label: {
                            Text("Food")
                                .font(.headline)
                                .mealsFoodStyle(width: geometry.size.width)
                        }
                        .padding(.top, 5)
                        .padding(.trailing, 40)
                    }
                    .padding(.bottom, 16)
                    
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
        .accentColor(.black)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
