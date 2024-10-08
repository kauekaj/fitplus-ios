//
//  RoundedCorner.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 08/10/24.
//

import SwiftUI

struct RoundedCorner: Shape {
    var cornerRadius: CGFloat = 0.0
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        return Path(path.cgPath)
    }
}
