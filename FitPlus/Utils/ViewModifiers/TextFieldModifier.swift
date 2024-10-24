//
//  TextFieldModifier.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 20/07/24.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal)
            .frame(height: 55)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
    }
}
