//
//  RecipesView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 01/10/24.
//

import Foundation
import SwiftUI

struct RecipeModel: Identifiable, Codable {
    let id: String
    let name: String
    let imageUrl: String
    let ingredients: [String]
}

final class RecipeListViewModel: ObservableObject {
    @Published var sweetRecipes: [RecipeModel] = []
    @Published var savoryRecipes: [RecipeModel] = []
    
    func fetchRecipesFromJson() {
        let mockJson = """
        {
            "sweet_recipes": [
                {
                    "id": "1",
                    "name": "Bolo de Chocolate",
                    "image_url": "https://via.placeholder.com/150",
                    "ingredients": ["Farinha", "Chocolate", "Açúcar", "Ovos", "Manteiga"]
                },
                {
                    "id": "2",
                    "name": "Torta de Limão",
                    "image_url": "https://via.placeholder.com/150",
                    "ingredients": ["Limão", "Leite Condensado", "Biscoito", "Creme de Leite"]
                },
                {
                    "id": "3",
                    "name": "Brigadeiro",
                    "image_url": "https://via.placeholder.com/150",
                    "ingredients": ["Leite Condensado", "Chocolate em Pó", "Manteiga"]
                },
                {
                    "id": "4",
                    "name": "Mousse de Maracujá",
                    "image_url": "https://via.placeholder.com/150",
                    "ingredients": ["Maracujá", "Leite Condensado", "Creme de Leite"]
                },
                {
                    "id": "5",
                    "name": "Pudim de Leite",
                    "image_url": "https://via.placeholder.com/150",
                    "ingredients": ["Leite Condensado", "Ovos", "Leite"]
                },
                {
                    "id": "6",
                    "name": "Beijinho",
                    "image_url": "https://via.placeholder.com/150",
                    "ingredients": ["Leite Condensado", "Coco Ralado", "Manteiga"]
                },
                {
                    "id": "7",
                    "name": "Cocada",
                    "image_url": "https://via.placeholder.com/150",
                    "ingredients": ["Coco", "Açúcar", "Leite"]
                },
                {
                    "id": "8",
                    "name": "Rabanada",
                    "image_url": "https://via.placeholder.com/150",
                    "ingredients": ["Pão", "Leite", "Ovos", "Açúcar"]
                },
                {
                    "id": "9",
                    "name": "Bolo de Cenoura",
                    "image_url": "https://via.placeholder.com/150",
                    "ingredients": ["Farinha", "Cenoura", "Açúcar", "Ovos"]
                },
                {
                    "id": "10",
                    "name": "Torta de Chocolate",
                    "image_url": "https://via.placeholder.com/150",
                    "ingredients": ["Chocolate", "Biscoito", "Manteiga", "Açúcar"]
                }
            ],
            "savory_recipes": [
                {
                    "id": "1",
                    "name": "Lasanha",
                    "image_url": "https://via.placeholder.com/150",
                    "ingredients": ["Massa", "Carne Moída", "Queijo", "Molho de Tomate"]
                },
                {
                    "id": "2",
                    "name": "Pizza",
                    "image_url": "https://via.placeholder.com/150",
                    "ingredients": ["Massa de Pizza", "Molho de Tomate", "Queijo", "Orégano"]
                },
                {
                    "id": "3",
                    "name": "Coxinha",
                    "image_url": "https://via.placeholder.com/150",
                    "ingredients": ["Frango Desfiado", "Massa de Coxinha", "Requeijão"]
                },
                {
                    "id": "4",
                    "name": "Bolinho de Bacalhau",
                    "image_url": "https://via.placeholder.com/150",
                    "ingredients": ["Bacalhau", "Batata", "Cebola", "Salsa"]
                },
                {
                    "id": "5",
                    "name": "Empada",
                    "image_url": "https://via.placeholder.com/150",
                    "ingredients": ["Massa", "Frango", "Catupiry"]
                },
                {
                    "id": "6",
                    "name": "Pastel",
                    "image_url": "https://via.placeholder.com/150",
                    "ingredients": ["Massa de Pastel", "Carne Moída", "Queijo"]
                },
                {
                    "id": "7",
                    "name": "Quiche",
                    "image_url": "https://via.placeholder.com/150",
                    "ingredients": ["Massa", "Queijo", "Bacon", "Ovos"]
                },
                {
                    "id": "8",
                    "name": "Esfiha",
                    "image_url": "https://via.placeholder.com/150",
                    "ingredients": ["Massa", "Carne Moída", "Cebola", "Tomate"]
                },
                {
                    "id": "9",
                    "name": "Torta Salgada",
                    "image_url": "https://via.placeholder.com/150",
                    "ingredients": ["Farinha", "Frango", "Cenoura", "Ervilha"]
                },
                {
                    "id": "10",
                    "name": "Feijoada",
                    "image_url": "https://via.placeholder.com/150",
                    "ingredients": ["Feijão Preto", "Carne de Porco", "Linguiça", "Farinha"]
                }
            ]
        }
        """
        
        let json_data = Data(mockJson.utf8)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let decodedData = try decoder.decode(RecipeResponse.self, from: json_data)
            self.sweetRecipes = decodedData.sweetRecipes
            self.savoryRecipes = decodedData.savoryRecipes
        } catch {
            print("Erro ao decodificar o JSON: \(error)")
        }
    }
}

struct RecipeResponse: Codable {
    let sweetRecipes: [RecipeModel]
    let savoryRecipes: [RecipeModel]
}

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    
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
            .background(Color.white)
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
            
            NavigationLink(destination: FullRecipeListView(category: category, recipes: recipes)) {
                Text("Ver mais")
                    .font(.callout)
                    .foregroundColor(.accentColor)
            }
        }
        .padding([.leading, .trailing])
    }
}

struct RecipesCarousel: View {
    let recipes: [RecipeModel]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(recipes.prefix(5)) { recipe in
                    RecipeCarouselCard(recipe: recipe)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct RecipeCarouselCard: View {
    let recipe: RecipeModel
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: recipe.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 100)
                    .cornerRadius(8)
            } placeholder: {
                ProgressView()
                    .frame(width: 150, height: 100)
            }
            
            Text(recipe.name)
                .font(.caption)
                .bold()
                .frame(width: 150)
                .multilineTextAlignment(.center)
                .padding(.vertical, 4)
        }
        .frame(width: 150)
        .padding(2)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: 2)
    }
}

struct FullRecipeListView: View {
    let category: String
    let recipes: [RecipeModel]

    @State private var searchText = ""

    var filteredRecipes: [RecipeModel] {
        if searchText.isEmpty {
            return recipes
        } else {
            return recipes.filter { recipe in
                recipe.name.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        List {
            ForEach(filteredRecipes) { recipe in
                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                    RecipeCard(recipe: recipe)
                }
                .listRowSeparator(.hidden)
            }
        }
        .navigationTitle("Receitas \(category)")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "Buscar receitas")
    }
}


struct RecipeDetailView: View {
    let recipe: RecipeModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                AsyncImage(url: URL(string: recipe.imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                        .cornerRadius(12)
                } placeholder: {
                    ProgressView()
                        .frame(height: 200)
                }
                
                Text(recipe.name)
                    .font(.largeTitle)
                    .bold()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Ingredientes:")
                        .font(.headline)
                        .padding(.top, 10)
                    
                    ForEach(recipe.ingredients, id: \.self) { ingredient in
                        Text(ingredient)
                            .font(.body)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)
            }
            .padding()
        }
        .navigationTitle("Detalhes da Receita")
        .navigationBarTitleDisplayMode(.inline)
        .scrollIndicators(.hidden)
    }
}


struct RecipeCard: View {
    let recipe: RecipeModel
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: recipe.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .cornerRadius(8)
            } placeholder: {
                ProgressView()
                    .frame(width: 100, height: 100)
            }
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.headline)
                Text(recipe.ingredients.first ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
    }
}


struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
    }
}
