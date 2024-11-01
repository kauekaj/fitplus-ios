//
//  RecipesCarouselCard.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 31/10/24.
//

import SwiftUI

struct RecipesCarouselCard: View {
    let recipe: RecipeModel
    
    var body: some View {
        VStack(spacing: 0) {
            AsyncImage(url: URL(string: recipe.imageUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 160, height: 110)
                    .clipped()
            } placeholder: {
                makeCarouselCardSkeletonView()
            }
            
            VStack(alignment: .center, spacing: 4) {
                Divider()
                    .padding(.horizontal, 8)
                    .background(Color.gray.opacity(0.5))
                Text(recipe.name ?? "")
                    .font(.headline)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
                
            }
            .padding(8)
            .frame(width: 160)
            .background(Color.white)
            .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
        }
        .frame(width: 160, height: 160)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 4)
        .padding(2)
    }
    
    func makeCarouselCardSkeletonView() -> some View {
        VStack(spacing: 0) {
            DSMShimmerEffectBox()
                .frame(width: 160, height: 110)
                .cornerRadius(8, corners: [.topLeft, .topRight])
        }
    }
}
