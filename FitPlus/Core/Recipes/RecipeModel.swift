//
//  RecipeModel.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 01/11/24.
//

import SwiftUI

struct RecipeModel: Identifiable, Codable {
    let id: String
    let name: String?
    let imageUrl: String?
    let ingredients: [String]?
    let instructions: String?
}

struct RecipeResponse: Codable {
    let sweetRecipes: [RecipeModel]
    let savoryRecipes: [RecipeModel]
}
