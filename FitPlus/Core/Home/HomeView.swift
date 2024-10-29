//
//  HomeView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 18/07/24.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var userRepository: UserRepository
    
    private var user: FitPlusUser? {
        userRepository.getUser()
    }
    
    private var firstName: String {
        user?.fullName?.split(separator: " ").first.map(String.init) ?? ""
    }
    
    var favoriteRecipes: [String] = []
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack() {
                    
                    HStack {
                        Text("Olá, \(firstName) 👋")
                            .font(.title2)
                            .bold()
                        
                        Spacer()
                        
                        Button(action: {
                            // To implement
                        }) {
                            Image(systemName: "bell.fill")
                                .font(.title3)
                                .foregroundColor(.black)
                                .padding(4)
                                .background(.gray.opacity(0.2))
                                .clipShape(Circle())
                        }
                    }
                    .padding()
                    
                    let homeCards = ["Mitos e verdades", "Listas", "???"]

                    HStack {
                        ForEach(Array(homeCards.enumerated()), id: \.element) { index, card in
                            NavigationLink(destination: Text("Tela \(card)")) {
                                Color.accentColor
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(8)
                                    .overlay(
                                        Text("\(card)")
                                            .foregroundColor(.white)
                                            .font(.headline)
                                    )
                            }
                            
                            if index < homeCards.count - 1 {
                                Spacer()
                            }
                        }
                    }
                    .padding(24)
                    
                    ZStack(alignment: .bottom) {
                        Image("dailyMessageCover")
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width - 16, height: 200)

                            .shadow(radius: 4)
                            .clipped()
                            .cornerRadius(16)
                        
                        Text("Já leu a mensagem do dia hoje?")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(8)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(8)
                            .padding(.bottom, 4)
                            .padding(.horizontal, 8)
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        Text("Receitas Favoritas")
                            .font(.headline)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                        
                        if favoriteRecipes.isEmpty {
                            NavigationLink(destination: RecipeListView()) {
                                ZStack(alignment: .bottom) {
                                    Image("emptyRecipe")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 150)
                                        .clipped()
                                        .cornerRadius(16)
                                    
                                    Text("Conheça nossas receitas")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .padding(8)
                                        .background(Color.black.opacity(0.6))
                                        .cornerRadius(8)
                                        .padding(.bottom, 4)
                                        .padding(.horizontal, 8)
                                }
                                .padding(.horizontal)
                            }


                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(favoriteRecipes, id: \.self) { recipe in
                                        Color.accentColor
                                            .frame(width: 120, height: 120)
                                            .cornerRadius(12)
                                            .overlay(
                                                Text(recipe)
                                                    .foregroundColor(.white)
                                                    .font(.headline)
                                            )
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(8)
                }
            }
        }
    }
}
