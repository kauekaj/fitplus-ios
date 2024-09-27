//
//  GrocerShopListView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 20/07/24.
//

import SwiftUI

final class GrocerShopListViewModel: ObservableObject {
        
    let itemsKey: String = "items_list"

//    @Published var items: [(userItems: ItemModel, item: ItemModel)] = []
    @Published private(set) var items: [ItemModel] = []

    init() { }
    
//    @MainActor
    // Criar a lista vazia e somente dentro dela, que vamos add os items criando uma collection nova dentro da lista
//    func getItems(listId: String) {
//
//        Task {
//            let userItems = try await ListsManager.shared.getItems(listId: listId)
//            
//            var localArray: [(userItems: ItemModel, item: ItemModel)] = []
//            for userItem in userItems {
//                if let item = try? await ListsManager.shared.getItem(listId: listId, itemId: userItem.id) {
//                    localArray.append((userItem, item))
//                }
//            }
//                                      
//            self.items = localArray
//
//        }
//
//    }
    
    @MainActor
    func getItems(listId: String) {
        Task {
            self.items = try await ListsManager.shared.getItems(listId: listId)
        }
    }
    
    // MARK: - Methods
    
    func deleteItem(indexSet: IndexSet) {
        items.remove(atOffsets: indexSet)
    }
    
    func moveItem(from: IndexSet, to: Int) {
        items.move(fromOffsets: from, toOffset: to)
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
    
}

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
                        .onDelete(perform: viewModel.deleteItem)
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
//        .task {
//            try? await viewModel.getItems(listId: listId)
//        }
        .onAppear {
            viewModel.getItems(listId: listId)
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
