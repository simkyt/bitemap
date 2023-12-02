//
//  MainScreenCustomization.swift
//  bitemap
//
//  Created by Simonas Kytra on 2023-08-29.
//

import Foundation
import SwiftUI

extension AnyTransition {
    static var customSlide: AnyTransition {
        let insertion = AnyTransition.move(edge: .leading)
        let removal = AnyTransition.move(edge: .trailing).combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

extension Color {
    public static var lightBlue: Color {
        return Color(red: 0.8274509803921568, green: 0.9176470588235294, blue: 0.9490196078431372).opacity(0.3)
    }
    
    public static var cream: Color {
        return Color(red: 0.9490196078431372, green: 0.9294117647058824, blue: 0.9098039215686274)
    }
    
    public static var softerWhite: Color {
        return Color(red: 0.9882352941176471, green: 0.984313725490196, blue: 0.9725490196078431)
    }

}

extension View {
    func calorieCounterStyle() -> some View {
        self
            .padding(35)
            .background(
                Circle()
                    .strokeBorder(AngularGradient(gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple, .red]), center: .center), lineWidth: 5)
                    .background(Circle().fill(Color.cream))
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
            )
            .foregroundStyle(.black)
    }
    
    func foodSearchBarStyle(width: CGFloat) -> some View {
        self
            .frame(width: width / 1.6)
            .padding(.horizontal, 20)
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 0.5)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
            )
            .padding(.leading, 13)
    }
    
    func barStyle(width: CGFloat) -> some View {
        self
            .frame(width: width * 0.8, height: 65)
            .foregroundColor(Color.black)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.black, lineWidth: 0.5)
                    .background(Color.softerWhite)
                    .cornerRadius(6)
                    .shadow(color: .gray, radius: 1, x: 0, y: 2)
            )
    }
    
    func foodBarStyle(width: CGFloat) -> some View {
        self
            .frame(width: width / 1.3)
            .foregroundStyle(.black)
            .padding(15)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.black, lineWidth: 0.5)
                    .background(Color.softerWhite)
                    .cornerRadius(6)
                    .shadow(color: .gray, radius: 1, x: 0, y: 2)
            )
            .padding(.horizontal, 20)
            .padding([.top, .bottom], 5)
    }
    
    func repastTrackBarStyle(width: CGFloat) -> some View {
        self
            .frame(width: width / 1.3)
            .foregroundColor(Color.black)
            .padding(15)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.black, lineWidth: 0.5)
                    .background(Color.softerWhite)
                    .cornerRadius(6)
                    .shadow(color: .gray, radius: 1, x: 0, y: 2)
            )
            .padding(.horizontal, 20)
            .padding([.top, .bottom], 10)
    }
    
    func servingSizeBarStyle(width: CGFloat) -> some View {
        self
            .frame(width: width * 0.12, alignment: .center)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 0.5)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(6)
                    .shadow(color: .gray, radius: 1, x: 0, y: 2)
            )
            .padding(.leading, 30)
    }
    
    func servingUnitBarStyle(width: CGFloat) -> some View {
        self
            .frame(width: width * 0.6, alignment: .leading)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 0.5)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(6)
                    .shadow(color: .gray, radius: 1, x: 0, y: 2)
            )
            .padding(.trailing, 30)
    }
    
    func mealsFoodStyle(width: CGFloat) -> some View {
        self
            .frame(width: width * 0.3, height: 50)
            .foregroundColor(Color.black)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.black, lineWidth: 0.5)
                    .background(Color.softerWhite)
                    .cornerRadius(6)
                    .shadow(color: .gray, radius: 1, x: 0, y: 2)
            )
    }
    
    func formRowStyle() -> some View {
        self
            .listRowBackground(Color.softerWhite)
    }
}

extension NumberFormatter {
    static var customDecimalFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        return formatter
    }

    func string(from value: Double?) -> String {
        return self.string(from: NSNumber(value: value ?? 0)) ?? "0"
    }
}
