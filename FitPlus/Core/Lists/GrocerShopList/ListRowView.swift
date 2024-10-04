//
//  ListRowView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 21/07/24.
//

import SwiftUI

struct ListRowView: View {
    
    let item: ItemModel
    
    var body: some View {
        HStack {
            Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                .foregroundColor(item.isCompleted ? .green : .accentColor)
            
            Text(item.title)
                .strikethrough(item.isCompleted ? true : false)
            
            Spacer()
        }
        .padding(.vertical)
//        .background(item.isCompleted ? Color.gray.opacity(0.1) : Color.clear)
        .font(.title2)
    }
}
