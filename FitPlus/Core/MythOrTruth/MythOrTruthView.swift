//
//  MythOrTruthView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 28/10/24.
//

import SwiftUI

struct MythOrTruthView: View {
    @StateObject var viewModel = MythOrTruthViewModel()
    
    var body: some View {
        DSMCustomNavigationBar(title: "Mitos e Verdades") {
            List {
                ForEach($viewModel.mythOrTruthList) { $item in
                    HStack {
                        Text(item.statement)
                            .font(.body)
                        Spacer()
                        if item.isRevealed {
                            Image(systemName: item.isTrue ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(item.isTrue ? .green : .red)
                        } else {
                            Image(systemName: "questionmark.circle")
                                .font(.system(size: 24))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .onTapGesture {
                        item.isRevealed.toggle()
                    }
                }
            }
        }
    }
}
