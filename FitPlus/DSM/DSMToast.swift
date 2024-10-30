//
//  DSMToast.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 29/10/24.
//

import SwiftUI

enum ToastType {
    case success
    case error
    case warning
    
    var toastColor: Color {
        switch self {
        case .success:
            return Color(red: 0.8, green: 1.0, blue: 0.8)
        case .error:
            return Color(red: 1.0, green: 0.8, blue: 0.8)
        case .warning:
            return Color(red: 1.0, green: 0.9, blue: 0.7)
        }
    }
    
    var iconName: String {
        switch self {
        case .success:
            return "checkmark.circle"
        case .error:
            return "exclamationmark.octagon"
        case .warning:
            return "exclamationmark.triangle"
        }
    }
    
    var iconColor: Color {
        switch self {
        case .success:
            return Color.green
        case .error:
            return Color.red
        case .warning:
            return Color.orange
        }
    }
}

struct DSMToast: View {
    let message: String
    let type: ToastType
    let autoDismiss: Bool
    let onDismiss: () -> Void

    var body: some View {
        VStack {
            HStack {
                Image(systemName: type.iconName)
                    .foregroundColor(type.iconColor)
                    .font(.system(size: 24, weight: .bold))
                
                Text(message)
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(6)
                }
                .background(Circle().fill(Color.gray.opacity(0.1)))
            }
            .padding(12)
            .background(type.toastColor)
            .cornerRadius(8)
            .transition(.opacity)
            .onAppear {
                if autoDismiss {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        withAnimation {
                            onDismiss()
                        }
                    }
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(type.iconColor.opacity(0.4), lineWidth: 1)
            )
            
            Spacer()
        }
        .padding(.horizontal, 8)
        .transition(.opacity)
    }
}
