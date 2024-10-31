//
//  ListsViewModel.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 31/10/24.
//

import SwiftUI

final class ListsViewModel: ObservableObject {
    @Published private(set) var lists: [ListModel] = []

    @MainActor
    func getUserLists() async throws {
        let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
        lists = try await ListsManager.shared.getUserLists(userId: userId).lists
    }
    
    @MainActor
    func deleteList(_ list: ListModel) async throws {
        try await ListsManager.shared.deleteList(listId: list.id)
        lists.removeAll { $0.id == list.id }
    }
}
