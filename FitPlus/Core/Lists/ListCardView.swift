//
//  ListCardView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 31/10/24.
//

import SwiftUI

struct ListCardView: View {
    let list: ListModel
    let onDelete: () -> Void
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "pencil.and.list.clipboard")
                .foregroundColor(.accentColor)
                .font(.title2)
                .padding(6)
                .background(Color(.systemBackground))
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(list.name ?? "")
                    .font(.headline)
                    .foregroundColor(.primary)
                if list.status == .inProgress {
                    HStack(spacing: 4) {
                        Image(systemName: "cart.fill")
                            .foregroundColor(.orange)
                        Text("Comprando...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.leading, 8)
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash.fill")
                    .foregroundColor(.red)
                    .font(.title3)
            }
        }
        .padding(12)
        .background(Color.accentColor.opacity(0.15))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 4)
        .padding(.horizontal, 8)
        .onTapGesture {
            onTap()
        }
    }
}
