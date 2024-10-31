//
//  ItemRowView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 21/07/24.
//

import SwiftUI

struct ItemRowView: View {
    
    let item: ItemModel
    
    var body: some View {
        HStack {
            Image(systemName: item.isCompleted ?? false ? "checkmark.circle.fill" : "circle")
                .foregroundColor(item.isCompleted ?? false ? .green : .accentColor)
            
            Text(item.title ?? "")
                .strikethrough(item.isCompleted ?? false ? true : false)
            
            Spacer()
        }
        .padding(.vertical, 8)
        .font(.title2)
    }
}
