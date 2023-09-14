//
//  ContentView.swift
//  bitemap
//
//  Created by Simonas Kytra on 2023-08-29.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @State var selectedDate: Date = {
        let now = Date()
        var calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: now)
        return calendar.date(from: components) ?? now
    }()

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Text("bitemap")
                        .font(.title.bold())
                        .scaleEffect(1.5)
                        .padding(geometry.size.height * 0.12)
                    
                    VStack {
                        Text("in total")
                            .font(.footnote)
                        Text("0")
                            .font(.title.bold())
                            .scaleEffect(1.5)
                            .padding(5)
                        Text("calories eaten")
                            .font(.footnote)
                            .padding(.bottom, geometry.size.height * 0.03)
                    }
                    
                    // date selection
                    HStack {
                        Button {
                            selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!
                        } label: {
                            Image(systemName: "lessthan")
                                .foregroundColor(Color.black)
                        }
                        
                        DatePicker("", selection: $selectedDate, displayedComponents: .date)
                            .scaleEffect(1.2)
                        
                        Button {
                            selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)!
                        } label: {
                            Image(systemName: "greaterthan")
                                .foregroundColor(Color.black)
                        }
                        .padding(.leading, 8)
                    }
                    .frame(width: geometry.size.width / 3)
                    .frame(width: geometry.size.width)
                    
                    Spacer()
                    
                    VStack {
                        NavigationLink {
                            RepastView(type: "breakfast", date: selectedDate, moc: moc)
                        } label: {
                            HStack {
                                Text("Breakfast")
                                    .font(.headline)
                                    .padding(.leading, 50)
                                Spacer()
                                VStack {
                                    Spacer()
                                    Text("0 kcal")
                                        .font(.footnote)
                                        .padding([.trailing, .bottom], 12)
                                }
                            }
                            .mealType(width: geometry.size.width)
                        }
                        .padding(10)
                        
                        NavigationLink {
                            RepastView(type: "lunch", date: selectedDate, moc: moc)
                        } label: {
                            HStack {
                                Text("Lunch")
                                    .font(.headline)
                                    .padding(.leading, 50)
                                Spacer()
                                VStack {
                                    Spacer()
                                    Text("0 kcal")
                                        .font(.footnote)
                                        .padding([.trailing, .bottom], 12)
                                }
                            }
                            .mealType(width: geometry.size.width)
                        }
                        .padding(10)
                        
                        NavigationLink {
                            RepastView(type: "Dinner", date: selectedDate, moc: moc)
                        } label: {
                            HStack {
                                Text("Dinner")
                                    .font(.headline)
                                    .padding(.leading, 50)
                                Spacer()
                                VStack {
                                    Spacer()
                                    Text("0 kcal")
                                        .font(.footnote)
                                        .padding([.trailing, .bottom], 12)
                                }
                            }
                            .mealType(width: geometry.size.width)
                        }
                        .padding(10)
                        
                        HStack {
                            NavigationLink {
                                
                            } label: {
                                    Text("Meals")
                                        .font(.headline)
                                .mealsFood(width: geometry.size.width)
                            }
                            .padding(.top, 5)
                            
                            NavigationLink {
                                FoodView(moc: moc)
                            } label: {
                                    Text("Food")
                                        .font(.headline)
                                .mealsFood(width: geometry.size.width)
                            }
                            .padding(.top, 5)
                        }
                    }
                    Spacer()
                    
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
