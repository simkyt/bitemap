//
//  KeyboardHelper.swift
//  bitemap
//
//  Created by Simonas Kytra on 02/12/2023.
//

import SwiftUI

// This is using UIKit to help with hiding the keyboard when pressing somewhere else on the view

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }

        guard let window = windowScene.windows.first else { return }

        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
