//
//  RecipesCarousel.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 31/10/24.
//

import SwiftUI

struct RecipesCarousel: View {
    let recipes: [RecipeModel]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(recipes.prefix(5)) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe).navigationBarHidden(true)) {
                        RecipesCarouselCard(recipe: recipe)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
