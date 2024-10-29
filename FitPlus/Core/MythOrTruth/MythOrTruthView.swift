//
//  MythOrTruthView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 28/10/24.
//

import SwiftUI

struct MythOrTruth: Identifiable {
    let id = UUID()
    let statement: String
    let isTrue: Bool
}

class MythOrTruthViewModel: ObservableObject {
    @Published var mythOrTruthList: [MythOrTruth] = [
        MythOrTruth(statement: "Beber água morna em jejum acelera o metabolismo", isTrue: false),
        MythOrTruth(statement: "Comer carboidratos à noite engorda", isTrue: false),
        MythOrTruth(statement: "Frutas são alimentos ricos em açúcar", isTrue: true),
        MythOrTruth(statement: "Comer de três em três horas ajuda a perder peso", isTrue: true)
    ]
}


struct MythOrTruthView: View {
    @StateObject var viewModel = MythOrTruthViewModel()
    
    var body: some View {
            CustomNavigationBar(title: "Mitos e Verdades") {
                List(viewModel.mythOrTruthList) { item in
                    HStack {
                        Text(item.statement)
                            .font(.body)
                        Spacer()
                        Image(systemName: item.isTrue ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(item.isTrue ? .green : .red)
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
    }
}
