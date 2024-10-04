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
    let instructions: String
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
              "name": "Bolo de Aveia e Banana",
              "image_url": "https://firebasestorage.googleapis.com/v0/b/fitplus-53f36.appspot.com/o/Recipes%2Fthumbnail%2Fbolo_aveia_banana.avif?alt=media&token=f779a3dd-2bed-4080-a3ca-493d7c027d92",
              "ingredients": ["Aveia", "Banana", "Ovos", "Mel", "Canela"],
              "instructions": "Pré-aqueça o forno a 180°C. Bata as bananas com os ovos, adicione aveia e mel. Misture tudo e leve ao forno por 30 minutos."
            },
            {
              "id": "2",
              "name": "Torta Integral de Maçã",
              "image_url": "https://firebasestorage.googleapis.com/v0/b/fitplus-53f36.appspot.com/o/Recipes%2Fthumbnail%2Ftorta_integral_de_maca.jpg?alt=media&token=6f0257a0-91f6-48e7-a493-955041cc44ec",
              "ingredients": ["Farinha Integral", "Maçã", "Mel", "Canela", "Ovos"],
              "instructions": "Misture a farinha com os ovos e o mel. Coloque as maçãs em fatias sobre a massa e asse por 25 minutos a 180°C."
            },
            {
              "id": "3",
              "name": "Brigadeiro Fit",
              "image_url": "https://firebasestorage.googleapis.com/v0/b/fitplus-53f36.appspot.com/o/Recipes%2Fthumbnail%2Fbrigadeiro_fit.png?alt=media&token=9b436f88-e9b4-4cd2-ac5c-58f403bd21b5",
              "ingredients": ["Leite de Coco", "Cacau em Pó", "Adoçante Natural"],
              "instructions": "Misture o leite de coco com cacau e adoçante. Leve ao fogo até engrossar e deixe esfriar antes de enrolar."
            },
            {
              "id": "4",
              "name": "Mousse de Abacate",
              "image_url": "https://firebasestorage.googleapis.com/v0/b/fitplus-53f36.appspot.com/o/Recipes%2Fthumbnail%2Fmousse_abacate.webp?alt=media&token=093a6851-07cc-4473-8636-f45032c6e5cd",
              "ingredients": ["Abacate", "Cacau em Pó", "Mel", "Leite de Coco"],
              "instructions": "Bata o abacate com leite de coco, cacau e mel até obter uma consistência cremosa. Refrigere antes de servir."
            },
            {
              "id": "5",
              "name": "Pudim de Chia",
              "image_url": "https://firebasestorage.googleapis.com/v0/b/fitplus-53f36.appspot.com/o/Recipes%2Fthumbnail%2Fpudim_chia.webp?alt=media&token=52f391b8-3ef9-4d51-87a2-b90bd62d7404",
              "ingredients": ["Sementes de Chia", "Leite de Amêndoas", "Adoçante Natural", "Frutas Vermelhas"],
              "instructions": "Misture chia com leite de amêndoas e adoçante. Deixe na geladeira por 2 horas. Sirva com frutas vermelhas."
            },
            {
              "id": "6",
              "name": "Beijinho Fit",
              "image_url": "https://firebasestorage.googleapis.com/v0/b/fitplus-53f36.appspot.com/o/Recipes%2Fthumbnail%2Fbeijinho_fit.jpg?alt=media&token=3776302a-17cf-40b6-9b6e-dd13a3d5ed89",
              "ingredients": ["Leite de Coco", "Coco Ralado", "Adoçante Natural"],
              "instructions": "Misture o leite de coco com coco ralado e adoçante. Cozinhe até engrossar. Modele os beijinhos e sirva."
            },
            {
              "id": "7",
              "name": "Cocada de Coco com Whey",
              "image_url": "https://firebasestorage.googleapis.com/v0/b/fitplus-53f36.appspot.com/o/Recipes%2Fthumbnail%2Fcocada_com_whey.jpg?alt=media&token=bd8fe2fa-0173-436a-9f86-b340d21e2b63",
              "ingredients": ["Coco Ralado", "Whey Protein", "Leite de Coco", "Adoçante Natural"],
              "instructions": "Misture coco ralado, whey e leite de coco. Cozinhe até engrossar e forme bolinhas ou barras."
            },
            {
              "id": "8",
              "name": "Bolo de Cenoura Fit",
              "image_url": "https://firebasestorage.googleapis.com/v0/b/fitplus-53f36.appspot.com/o/Recipes%2Fthumbnail%2Fbolo_de_cenoura.jpg?alt=media&token=416f6fd6-9731-4e72-8960-fa100d46df14",
              "ingredients": ["Cenoura", "Farinha de Amêndoas", "Ovos", "Azeite", "Mel"],
              "instructions": "Bata a cenoura com os ovos e azeite. Adicione a farinha de amêndoas e o mel. Asse a 180°C por 35 minutos."
            },
            {
              "id": "9",
              "name": "Brownie de Batata Doce",
              "image_url": "https://firebasestorage.googleapis.com/v0/b/fitplus-53f36.appspot.com/o/Recipes%2Fthumbnail%2Fbrownie_proteico_batata_doce.jpg?alt=media&token=9acd6daf-e21c-4959-9985-4a77263a8151",
              "ingredients": ["Batata Doce", "Cacau em Pó", "Ovos", "Farinha de Amêndoas", "Adoçante Natural"],
              "instructions": "Misture batata doce cozida com cacau, ovos e farinha de amêndoas. Asse por 25 minutos a 180°C."
            },
            {
              "id": "10",
              "name": "Panqueca de Banana e Aveia",
              "image_url": "https://firebasestorage.googleapis.com/v0/b/fitplus-53f36.appspot.com/o/Recipes%2Fthumbnail%2FPanqueca_de_banana_aveia.jpeg?alt=media&token=43045dd5-7355-472f-a63e-f08c8ae63280",
              "ingredients": ["Banana", "Aveia", "Ovos", "Canela"],
              "instructions": "Amasse a banana e misture com ovos e aveia. Frite pequenas porções em uma frigideira antiaderente até dourar."
            }
          ],
          "savory_recipes": [
            {
              "id": "1",
              "name": "Lasanha de Abobrinha",
              "image_url": "https://www.example.com/images/fit_lasanha_abobrinha.jpg",
              "ingredients": ["Abobrinha", "Molho de Tomate", "Queijo Cottage", "Frango Desfiado"],
              "instructions": "Corte a abobrinha em fatias e monte camadas com molho de tomate, queijo cottage e frango. Asse por 30 minutos."
            },
            {
              "id": "2",
              "name": "Pizza Integral de Frango",
              "image_url": "https://www.example.com/images/fit_pizza_integral_frango.jpg",
              "ingredients": ["Massa Integral", "Frango Desfiado", "Molho de Tomate", "Queijo Light"],
              "instructions": "Espalhe o molho na massa, adicione frango desfiado e queijo. Asse a 200°C por 15 minutos."
            },
            {
              "id": "3",
              "name": "Coxinha Fit de Batata Doce",
              "image_url": "https://www.example.com/images/fit_coxinha_batata_doce.jpg",
              "ingredients": ["Batata Doce", "Frango Desfiado", "Farinha de Linhaça"],
              "instructions": "Misture batata doce cozida com farinha de linhaça. Recheie com frango desfiado e asse até dourar."
            },
            {
              "id": "4",
              "name": "Bolinho de Quinoa",
              "image_url": "https://www.example.com/images/fit_bolinho_quinoa.jpg",
              "ingredients": ["Quinoa", "Ovos", "Cebola", "Cenoura"],
              "instructions": "Cozinhe a quinoa e misture com ovos e vegetais. Molde bolinhos e asse a 180°C por 20 minutos."
            },
            {
              "id": "5",
              "name": "Empada de Aveia e Frango",
              "image_url": "https://www.example.com/images/fit_empada_frango.jpg",
              "ingredients": ["Aveia", "Frango Desfiado", "Requeijão Light"],
              "instructions": "Prepare uma massa com aveia e recheie com frango e requeijão light. Asse por 25 minutos a 180°C."
            },
            {
              "id": "6",
              "name": "Pastel Assado Integral",
              "image_url": "https://www.example.com/images/fit_pastel_integral.jpg",
              "ingredients": ["Massa Integral", "Carne Moída Magra", "Cebola"],
              "instructions": "Recheie a massa integral com carne moída. Asse a 200°C por 20 minutos."
            },
            {
              "id": "7",
              "name": "Quiche de Espinafre e Queijo Branco",
              "image_url": "https://www.example.com/images/fit_quiche_espinafre.jpg",
              "ingredients": ["Farinha Integral", "Espinafre", "Queijo Branco", "Ovos"],
              "instructions": "Misture farinha com ovos e espinafre. Asse em uma forma com recheio de queijo branco."
            },
            {
              "id": "8",
              "name": "Esfiha Integral de Carne",
              "image_url": "https://www.example.com/images/fit_esfiha_integral.jpg",
              "ingredients": ["Massa Integral", "Carne Moída Magra", "Cebola", "Tomate"],
              "instructions": "Recheie a massa integral com carne temperada. Asse a 180°C por 15 minutos."
            },
            {
              "id": "9",
              "name": "Torta Salgada de Legumes",
              "image_url": "https://www.example.com/images/fit_torta_legumes.jpg",
              "ingredients": ["Farinha Integral", "Ovos", "Cenoura", "Brócolis"],
              "instructions": "Misture farinha com ovos e vegetais picados. Asse a 180°C por 30 minutos."
            },
            {
              "id": "10",
              "name": "Feijoada Light",
              "image_url": "https://www.example.com/images/fit_feijoada.jpg",
              "ingredients": ["Feijão Preto", "Peito de Frango", "Linguiça de Frango", "Couve"],
              "instructions": "Cozinhe o feijão e adicione peito de frango e linguiça de frango. Sirva com couve refogada."
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
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                        RecipeCarouselCard(recipe: recipe)
                    }
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
        .scrollContentBackground(.hidden)
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
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Ingredientes:")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(Color.gray.opacity(0.2)))
                        .padding(.top, 16)
                    
                    ForEach(recipe.ingredients, id: \.self) { ingredient in
                        Text("- \(ingredient)")
                            .font(.body)
                    }
                    
                    Text("Modo de preparo:")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(Color.gray.opacity(0.2)))
                        .padding(.top, 16)
                    
                    Text(recipe.instructions)
                        .font(.body)
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