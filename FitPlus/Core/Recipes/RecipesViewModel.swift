//
//  RecipesViewModel.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 31/10/24.
//

import SwiftUI

final class RecipesViewModel: ObservableObject {
    
    @Published var sweetRecipes: [RecipeModel] = []
    @Published var savoryRecipes: [RecipeModel] = []
    
    func fetchRecipesFromJson() {
        let recipes = getRecipesJson()
        
        let json_data = Data(recipes.utf8)
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

extension RecipesViewModel {
    
    func getRecipesJson() -> String {
        let recipesJson = """
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
          "image_url": "https://firebasestorage.googleapis.com/v0/b/fitplus-53f36.appspot.com/o/Recipes%2Fthumbnail%2Flasanha_de_bobrinha.jpg?alt=media&token=89e34380-807d-41de-822f-a5140c4f8cec",
          "ingredients": ["Abobrinha", "Molho de Tomate", "Queijo Cottage", "Frango Desfiado"],
          "instructions": "Corte a abobrinha em fatias e monte camadas com molho de tomate, queijo cottage e frango. Asse por 30 minutos."
        },
        {
          "id": "2",
          "name": "Pizza Integral de Frango",
          "image_url": "https://firebasestorage.googleapis.com/v0/b/fitplus-53f36.appspot.com/o/Recipes%2Fthumbnail%2Fpizza_integral_de_frango.png?alt=media&token=967fc5f9-376b-49b6-9c52-a2526990c5d4",
          "ingredients": ["Massa Integral", "Frango Desfiado", "Molho de Tomate", "Queijo Light"],
          "instructions": "Espalhe o molho na massa, adicione frango desfiado e queijo. Asse a 200°C por 15 minutos."
        },
        {
          "id": "3",
          "name": "Coxinha Fit de Batata Doce",
          "image_url": "https://firebasestorage.googleapis.com/v0/b/fitplus-53f36.appspot.com/o/Recipes%2Fthumbnail%2Fcoxinha_fit_de_batata_doce.jpg?alt=media&token=0428899f-764d-4d8f-85f2-b6e98802c08d",
          "ingredients": ["Batata Doce", "Frango Desfiado", "Farinha de Linhaça"],
          "instructions": "Misture batata doce cozida com farinha de linhaça. Recheie com frango desfiado e asse até dourar."
        },
        {
          "id": "4",
          "name": "Bolinho de Quinoa",
          "image_url": "https://firebasestorage.googleapis.com/v0/b/fitplus-53f36.appspot.com/o/Recipes%2Fthumbnail%2Fbolinho_de_quinoa.jpg?alt=media&token=6d9e9af7-11f4-421c-8e64-ce046f970703",
          "ingredients": ["Quinoa", "Ovos", "Cebola", "Cenoura"],
          "instructions": "Cozinhe a quinoa e misture com ovos e vegetais. Molde bolinhos e asse a 180°C por 20 minutos."
        },
        {
          "id": "5",
          "name": "Empada de Aveia e Frango",
          "image_url": "https://firebasestorage.googleapis.com/v0/b/fitplus-53f36.appspot.com/o/Recipes%2Fthumbnail%2Fempada_de_aveia_frango.jpg?alt=media&token=9282604c-ccee-41a9-b6b3-7c334bd2dd7c",
          "ingredients": ["Aveia", "Frango Desfiado", "Requeijão Light"],
          "instructions": "Prepare uma massa com aveia e recheie com frango e requeijão light. Asse por 25 minutos a 180°C."
        },
        {
          "id": "6",
          "name": "Pastel Assado Integral",
          "image_url": "https://firebasestorage.googleapis.com/v0/b/fitplus-53f36.appspot.com/o/Recipes%2Fthumbnail%2Fpastel_assado_integral.jpg?alt=media&token=1b2866f7-a549-4d5d-af51-0ed465fc1728",
          "ingredients": ["Massa Integral", "Carne Moída Magra", "Cebola"],
          "instructions": "Recheie a massa integral com carne moída. Asse a 200°C por 20 minutos."
        },
        {
          "id": "7",
          "name": "Quiche de Espinafre e Queijo Branco",
          "image_url": "https://firebasestorage.googleapis.com/v0/b/fitplus-53f36.appspot.com/o/Recipes%2Fthumbnail%2Fquiche_de_espinafre_queijo_branco.avif?alt=media&token=299cd99f-2a0f-4a37-8484-bc036abac59e",
          "ingredients": ["Farinha Integral", "Espinafre", "Queijo Branco", "Ovos"],
          "instructions": "Misture farinha com ovos e espinafre. Asse em uma forma com recheio de queijo branco."
        },
        {
          "id": "8",
          "name": "Esfiha Integral de Carne",
          "image_url": "https://firebasestorage.googleapis.com/v0/b/fitplus-53f36.appspot.com/o/Recipes%2Fthumbnail%2Fesfiha_integral_de_carne.png?alt=media&token=b0461588-9f0b-4074-84c1-6953c317657e",
          "ingredients": ["Massa Integral", "Carne Moída Magra", "Cebola", "Tomate"],
          "instructions": "Recheie a massa integral com carne temperada. Asse a 180°C por 15 minutos."
        },
        {
          "id": "9",
          "name": "Torta Salgada de Legumes",
          "image_url": "https://firebasestorage.googleapis.com/v0/b/fitplus-53f36.appspot.com/o/Recipes%2Fthumbnail%2Ftorta_salgada_de_legumes.jpg?alt=media&token=5dc8ada4-956a-48a3-a0fe-e02941d366e6",
          "ingredients": ["Farinha Integral", "Ovos", "Cenoura", "Brócolis"],
          "instructions": "Misture farinha com ovos e vegetais picados. Asse a 180°C por 30 minutos."
        },
        {
          "id": "10",
          "name": "Feijoada Light",
          "image_url": "https://firebasestorage.googleapis.com/v0/b/fitplus-53f36.appspot.com/o/Recipes%2Fthumbnail%2Ffeijoada_light.jpg?alt=media&token=d8541d90-9bb0-4c2e-bdfa-811e0bfa10d9",
          "ingredients": ["Feijão Preto", "Peito de Frango", "Linguiça de Frango", "Couve"],
          "instructions": "Cozinhe o feijão e adicione peito de frango e linguiça de frango. Sirva com couve refogada."
        }
      ]
    }
    
    """
        return recipesJson
    }
}
