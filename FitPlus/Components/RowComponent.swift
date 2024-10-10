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
    let destination: AnyView?
}

struct RowComponent: View {
    var verticalPadding: CGFloat?
    var horizontalPadding: CGFloat?
    var font: Font?
    var icon: Bool?
    var destination: Bool?
    var rowData: RowData
    
    var body: some View {
        HStack(spacing: 0) {
            if icon ?? false {
                Image(systemName: rowData.icon)
                    .foregroundColor(.black)
                    .frame(width: 36, height: 36)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            
            
            Text(rowData.text)
                .font((font != nil) ? font : .system(size: 16, weight: .semibold))
                .foregroundColor(.black)
                .padding(.leading, (icon != nil) ? 8 : 0)
            
            Spacer()
            
            if destination ?? false {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
     
        }
        .padding(.horizontal, (horizontalPadding != nil) ? horizontalPadding : 6)
        .padding(.vertical, (verticalPadding != nil) ? verticalPadding : 8)
    }
}
