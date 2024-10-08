//
//  RowComponent.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 08/10/24.
//

import SwiftUI

struct RowData: Identifiable {
    let id = UUID()
    let icon: String
    let text: String
    let destination: AnyView
}

struct RowComponent: View {
    var rowData: RowData
    
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: rowData.icon)
                .foregroundColor(.black)
                .frame(width: 36, height: 36)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            
            Text(rowData.text)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
                .padding(.leading, 8)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 8)
    }
}
