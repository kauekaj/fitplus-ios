//
//  GrocerShopListView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 20/07/24.
//

import Combine
import SwiftUI

final class GrocerShopListViewModel: ObservableObject {
    
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
//    func getItemsFromUserDefaults() {
//        guard
//            let data = UserDefaults.standard.data(forKey: itemsKey),
//            let savedItems = try? JSONDecoder().decode([ItemModel].self, from: data)
//        else { return }
//
//        self.items = savedItems
//    }
    
//    func addItem(title: String) {
//        let newItem = ItemModel(title: title, isCompleted: false)
//        items.append(newItem)
//    }
    
//    func updateItem(item: ItemModel) {
//        if let index = items.firstIndex(where: { $0.id == item.id }) {
//            items[index] = item.updateCompletion()
//        }
//    }
    
//    func saveItems() {
//        if let encodedData = try? JSONEncoder().encode(items) {
//            UserDefaults.standard.set(encodedData, forKey: itemsKey)
//        }
//    }

struct ItemCellViewBuilder: View {
    
    let itemId: String
    let listId: String
    @State private var item: ItemModel? = nil
    
    var body: some View {
        ZStack {
            if let item {
                ListRowView(item: item)
            }
        }
        .task {
            self.item = try? await ListsManager.shared.getItem(listId: listId, itemId: itemId)
        }
    }
}

struct GrocerShopListView: View {
    
    @ObservedObject var viewModel: GrocerShopListViewModel
    @State var listId: String = ""
    
    init(listId: String, viewModel: GrocerShopListViewModel) {
        self.listId = listId
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            if viewModel.items.isEmpty {
                makeEmptyView()
            } else {
                VStack {
                    HStack {
                        Text("ordenar")
                        Text("add")
                        
                    }
                    .padding()
                    
                    List {
                        ForEach(viewModel.items) { item in
                            ItemCellViewBuilder(itemId: item.id, listId: listId)
//                            ListRowView(item: item)
                                .onTapGesture {
                                    withAnimation(.linear) {
//                                        viewModel.updateItem(item: item)
                                    }
                                }
                        }
                        .onDelete { indexSet in
                                viewModel.deleteItem(listId: listId, indexSet: indexSet)
                            }
//                        .onDelete(perform: viewModel.deleteItem)
                        .onMove(perform: viewModel.moveItem)
                    }
                    .listStyle(PlainListStyle())
                }
                
            }
        }
        .navigationTitle("Lista de Compras 📝")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarItems(
            trailing:
                NavigationLink(destination: AddView(listId: listId)) {
                    Image(systemName: "person.fill.badge.plus")
                        .font(.title2)
                }
        )
        .onFirstAppear {
            viewModel.addListenerForListItems(listId: listId)
        }
    }
    
    
    func makeEmptyView() -> some View {
        VStack {
            Text("Sua lista está vazia")
                .font(.title2)
            Button {
                Task {
                    try await ListsManager.shared.addItem(listId: listId)
                }
            } label: {
                Image(systemName: "cart.fill.badge.plus")
                    .font(.largeTitle)
            }

//            NavigationLink(destination: AddView(listId: listId)) {
//                Image(systemName: "cart.fill.badge.plus")
//                    .font(.largeTitle)
//            }
            .padding()
        }
    }
    
}

#Preview {
    NavigationStack {
        GrocerShopListView(listId: "123", viewModel: GrocerShopListViewModel())
    }
}
