//
//  MainScreenCustomization.swift
//  bitemap
//
//  Created by Simonas Kytra on 2023-08-29.
//

import Foundation
import SwiftUI

extension View {
    func mealType(width: CGFloat) -> some View {
        self
            .frame(width: width * 0.8, height: 50)
            .foregroundColor(Color.black)
            .border(Color.black, width: 0.5)
 //           .padding(30)
    }
}
