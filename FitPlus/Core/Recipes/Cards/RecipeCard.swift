//
//  RecipeCard.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 31/10/24.
//

import SwiftUI

struct RecipeCard: View {
    let recipe: RecipeModel
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: recipe.imageUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .cornerRadius(8)
            } placeholder: {
                makeRecipeCardSkeletonView()
            }
            VStack(alignment: .leading) {
                Text(recipe.name ?? "")
                    .font(.headline)
                Text(recipe.ingredients?.first ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
    }
    
    func makeRecipeCardSkeletonView() -> some View {
        VStack(spacing: 0) {
            DSMShimmerEffectBox()
                .frame(width: 100, height: 100)
                .cornerRadius(8, corners: .allCorners)
        }
    }
}
