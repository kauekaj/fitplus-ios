//
//  TopHalfCircle.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 30/10/24.
//

import SwiftUI

struct TopHalfCircle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: rect.width / 2,
                    startAngle: .degrees(180),
                    endAngle: .degrees(0),
                    clockwise: false)
        return path
    }
}
