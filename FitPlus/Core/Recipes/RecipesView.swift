//
//  RecipesView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 01/10/24.
//

import Foundation
import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipesViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Section(header: makeSectionHeader(name: "Doces", category: "Doces", recipes: viewModel.sweetRecipes)) {
                            RecipesCarousel(recipes: viewModel.sweetRecipes)
                        }
                        
                        Section(header: makeSectionHeader(name: "Salgadas", category: "Salgadas", recipes: viewModel.savoryRecipes)) {
                            RecipesCarousel(recipes: viewModel.savoryRecipes)
                        }
                    }
                    .padding(.top, 16)
                }
            }
            .onAppear {
                viewModel.fetchRecipesFromJson()
            }
            .navigationTitle("Receitas")
        }
    }
    
    func makeSectionHeader(name: String, category: String, recipes: [RecipeModel]) -> some View {
        HStack {
            Text(name)
                .font(.title2)
                .bold()
            
            Spacer()
            
            NavigationLink(destination: RecipesListView(category: category, recipes: recipes).navigationBarHidden(true)) {
                Text("Ver mais")
                    .font(.callout)
                    .foregroundColor(.accentColor)
            }
        }
        .padding([.leading, .trailing])
    }
}
