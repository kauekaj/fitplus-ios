//
//  GrocerListViewModel.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 31/10/24.
//

import Combine
import SwiftUI

final class GrocerListViewModel: ObservableObject {
    
    // To Check
    let itemsKey: String = "items_list"
    
    @Published private(set) var items: [ItemModel] = []
    private var cancellabes = Set<AnyCancellable>()
    
    @MainActor
    func getItems(listId: String) {
        Task {
            self.items = try await ListsManager.shared.getItems(listId: listId)
        }
    }
    
    func addListenerForListItems(listId: String) {
        ListsManager.shared.addListenerForListItems(listId: listId)
            .sink { completion in
                
            } receiveValue: { [weak self] items in
                self?.items = items
            }
            .store(in: &cancellabes)
    }
    
    // MARK: - Methods
    
    @MainActor
    func toggleItemStatus(listId: String, itemId: String, isCompleted: Bool) {
        Task {
            try await ListsManager.shared.updateItemStatus(listId: listId, itemId: itemId, iscompleted: isCompleted)

            if let index = items.firstIndex(where: { $0.id == itemId }) {
                items[index].isCompleted = isCompleted
            }
        }
    }

    func deleteItem(listId: String , indexSet: IndexSet) {
        Task {
            if let index = indexSet.first {
                let itemId = items[index].id
                try await ListsManager.shared.removeListItem(listId: listId, itemId: itemId)
            }
        }
    }
    
    func moveItem(from: IndexSet, to: Int) {
        items.move(fromOffsets: from, toOffset: to)
    }
}
