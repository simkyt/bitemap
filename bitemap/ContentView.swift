//
//  ContentView.swift
//  bitemap
//
//  Created by Simonas Kytra on 2023-08-29.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedDate = Date.now

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Text("bitemap")
                        .font(.title.bold())
                        .padding(geometry.size.height * 0.12)

                    
                    VStack {
                        Text("in total")
                            .font(.footnote)
                        Text("0")
                            .font(.title.bold())
                        Text("calories eaten")
                            .font(.footnote)
                            .padding(.bottom, geometry.size.height * 0.03)
                    }
                    
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .scaleEffect(1.5)
                        .frame(width: geometry.size.width / 3)
                        .frame(width: geometry.size.width)
                    
                    Spacer()
                    
                    VStack {
                        NavigationLink {
                            
                        } label: {
                            HStack {
                                Text("Breakfast")
                                    .font(.headline)
                                    .padding(.leading, 40)
                                Spacer()
                                VStack {
                                    Spacer()
                                    Text("0 kcal")
                                        .font(.footnote)
                                        .padding([.trailing, .bottom], 10)
                                }
                            }
                            .mealType(width: geometry.size.width)
                        }
                        .padding(20)
                        
                        NavigationLink {
                            
                        } label: {
                            HStack {
                                Text("Lunch")
                                    .font(.headline)
                                    .padding(.leading, 40)
                                Spacer()
                                VStack {
                                    Spacer()
                                    Text("0 kcal")
                                        .font(.footnote)
                                        .padding([.trailing, .bottom], 10)
                                }
                            }
                            .mealType(width: geometry.size.width)
                        }
                        .padding(20)
                        
                        NavigationLink {
                            
                        } label: {
                            HStack {
                                Text("Dinner")
                                    .font(.headline)
                                    .padding(.leading, 40)
                                Spacer()
                                VStack {
                                    Spacer()
                                    Text("0 kcal")
                                        .font(.footnote)
                                        .padding([.trailing, .bottom], 10)
                                }
                            }
                            .mealType(width: geometry.size.width)
                        }
                        .padding(20)
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
