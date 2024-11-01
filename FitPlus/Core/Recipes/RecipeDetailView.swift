//
//  RecipeDetailView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 31/10/24.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: RecipeModel
    
    var body: some View {
        DSMCustomNavigationBar(title: recipe.name ?? "") {
            ScrollView {
                VStack(alignment: .center) {
                    AsyncImage(url: URL(string: recipe.imageUrl ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 350, height: 200)
                            .cornerRadius(12)
                    } placeholder: {
                        makeRecipeBannerSkeletonView()
                    }
                    
                    Text(recipe.name ?? "")
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
                        
                        ForEach(recipe.ingredients ?? [], id: \.self) { ingredient in
                            Text("- \(ingredient)")
                                .font(.body)
                        }
                        
                        Text("Modo de preparo:")
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Capsule().fill(Color.gray.opacity(0.2)))
                            .padding(.top, 16)
                        
                        Text(recipe.instructions ?? "")
                            .font(.body)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
                }
                .padding()
            }
            .scrollIndicators(.hidden)
        }
    }
    
    func makeRecipeBannerSkeletonView() -> some View {
        VStack(spacing: 0) {
            DSMShimmerEffectBox()
                .frame(width: 350, height: 200)
                .cornerRadius(8, corners: [.topLeft, .topRight])
        }
    }
}
