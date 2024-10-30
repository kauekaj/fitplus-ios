//
//  MythOrTruthViewModel.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 30/10/24.
//

import SwiftUI

struct MythOrTruthModel: Identifiable {
    let id = UUID()
    let statement: String
    let isTrue: Bool
    var isRevealed: Bool = false
}

final class MythOrTruthViewModel: ObservableObject {
    @Published var mythOrTruthList: [MythOrTruthModel] = [
        MythOrTruthModel(statement: "Beber água morna em jejum acelera o metabolismo", isTrue: false),
        MythOrTruthModel(statement: "Comer carboidratos à noite engorda", isTrue: false),
        MythOrTruthModel(statement: "Frutas são alimentos ricos em açúcar", isTrue: true),
        MythOrTruthModel(statement: "Comer de três em três horas ajuda a perder peso", isTrue: true),
        MythOrTruthModel(statement: "Oito copos de água por dia são suficientes para todos", isTrue: false),
        MythOrTruthModel(statement: "Fazer exercício em jejum queima mais gordura", isTrue: true),
        MythOrTruthModel(statement: "Dietas detox são uma maneira eficaz de perder peso", isTrue: false),
        MythOrTruthModel(statement: "O consumo de ovo aumenta o colesterol ruim", isTrue: false),
        MythOrTruthModel(statement: "A gordura faz mal à saúde", isTrue: false),
        MythOrTruthModel(statement: "Comer chocolate causa acne", isTrue: false),
        MythOrTruthModel(statement: "Treinos curtos são menos eficazes que treinos longos", isTrue: false),
        MythOrTruthModel(statement: "Bebidas energéticas são seguras para todos", isTrue: false),
        MythOrTruthModel(statement: "Alimentos 'light' são sempre mais saudáveis", isTrue: false),
        MythOrTruthModel(statement: "O jejum intermitente é eficaz para perda de peso", isTrue: true),
        MythOrTruthModel(statement: "A ingestão de proteínas deve ser maior após os 40 anos", isTrue: true),
        MythOrTruthModel(statement: "A maioria das pessoas precisa de suplementos vitamínicos", isTrue: false),
        MythOrTruthModel(statement: "Os carboidratos devem ser evitados para emagrecer", isTrue: false),
        MythOrTruthModel(statement: "O estresse pode contribuir para o ganho de peso", isTrue: true),
        MythOrTruthModel(statement: "Alimentos processados são sempre ruins", isTrue: false),
        MythOrTruthModel(statement: "A comida picante acelera o metabolismo", isTrue: true)
    ]

}
