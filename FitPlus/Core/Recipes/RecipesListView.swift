//
//  RecipesListView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 31/10/24.
//

import SwiftUI

struct RecipesListView: View {
    let category: String
    let recipes: [RecipeModel]
    
    @State private var searchText = ""
    
    var filteredRecipes: [RecipeModel] {
        if searchText.isEmpty {
            return recipes
        } else {
            return recipes.filter { recipe in
                if let name = recipe.name {
                    return name.lowercased().contains(searchText.lowercased())
                }
                return false
            }
        }
    }
    
    var body: some View {
        DSMCustomNavigationBar(title: "Receitas \(category)") {
            List {
                makeSearchBar()
                
                ForEach(filteredRecipes) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe).navigationBarHidden(true)) {
                        RecipeCard(recipe: recipe)
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
        }
        .navigationBarHidden(true)
    }
    
    func makeSearchBar() -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 8)
            TextField("Buscar receita", text: $searchText)
                .padding(8)
        }
        .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.1)))
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.vertical, 8)
    }
}
