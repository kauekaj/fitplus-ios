//
//  DSMButton.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 29/10/24.
//

import SwiftUI

enum ButtonState {
    case idle
    case loading
    case disabled
}

struct DSMButton: View {
    var title: String
    @Binding var state: ButtonState
    var action: () -> Void
    
    @State private var dotCount = 0
    
    var body: some View {
        Button(action: {
            if state == .idle {
                action()
                startLoadingAnimation()
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.accentColor)
                    .frame(height: 48)

                if state == .loading {
                    loadingView()
                } else {
                    Text(title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private func loadingView() -> some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .frame(width: index == dotCount ? 10 : 7, height: index == dotCount ? 10 : 7)
                    .foregroundColor(.white)
            }
        }
    }

    private func startLoadingAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            if state != .loading {
                timer.invalidate()
            } else {
                dotCount = (dotCount + 1) % 3
            }
        }
    }
}
