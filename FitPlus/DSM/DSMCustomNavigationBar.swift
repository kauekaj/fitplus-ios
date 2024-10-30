//
//  DSMCustomNavigationBar.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 29/10/24.
//

import SwiftUI

struct DSMCustomNavigationBar<Content: View>: View {
    var title: String
    var rightIcon: String?
    var rightAction: (() -> Void)?
    var content: () -> Content
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .font(.title3)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                Text(title)
                    .font(.headline)
                    .bold()
                
                Spacer()
                
                if let icon = rightIcon {
                    Button(action: {
                        rightAction?()
                    }) {
                        Image(systemName: icon)
                            .foregroundColor(.black)
                            .font(.title2)
                            .padding(4)
                    }
                } else {
                    Spacer()
                        .frame(width: 24)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            
            Divider()
            
            content()
            
            Spacer()
        }
    }
}
