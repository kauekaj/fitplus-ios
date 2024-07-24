//
//  GrocerShopListView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 20/07/24.
//

import SwiftUI

final class GrocerShopListViewModel: ObservableObject {
        
    @Published var mockItems: [ItemModel] = [
        ItemModel(title: "First item", isCompleted: false),
        ItemModel(title: "Second item", isCompleted: true),
        ItemModel(title: "Third item", isCompleted: false)
    ]
    
        @Published var items: [ItemModel] = [] {
            didSet {
                saveItems()
            }
        }
        
        let itemsKey: String = "items_list"
        
        init() {
            getItems()
        }
        
        func getItems() {
            guard
                let data = UserDefaults.standard.data(forKey: itemsKey),
                let savedItems = try? JSONDecoder().decode([ItemModel].self, from: data)
            else { return }
          
            self.items = savedItems
        }
        
        // MARK: - Methods
        
        func deleteItem(indexSet: IndexSet) {
            items.remove(atOffsets: indexSet)
        }
        
        func moveItem(from: IndexSet, to: Int) {
            items.move(fromOffsets: from, toOffset: to)
        }
        
        func addItem(title: String) {
            let newItem = ItemModel(title: title, isCompleted: false)
            items.append(newItem)
        }
        
        func updateItem(item: ItemModel) {
            if let index = items.firstIndex(where: { $0.id == item.id }) {
                items[index] = item.updateCompletion()
            }
        }
    
        func saveItems() {
            if let encodedData = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encodedData, forKey: itemsKey)
            }
        }

}

struct GrocerShopListView: View {

    @StateObject var listViewModel = GrocerShopListViewModel()

    var body: some View {
        ZStack {
            if listViewModel.items.isEmpty {
                makeEmptyView()
            } else {
                VStack {
                    HStack {
                        Text("ordenar")
                        Text("add")
                        
                    }
                    .padding()
                    
                    List {
                        ForEach(listViewModel.items) { item in
                            ListRowView(item: item)
                                .onTapGesture {
                                    withAnimation(.linear) {
                                        listViewModel.updateItem(item: item)
                                    }
                                }
                        }
                        .onDelete(perform: listViewModel.deleteItem)
                        .onMove(perform: listViewModel.moveItem)
                    }
                    .listStyle(PlainListStyle())
                }
                
            }
        }
        .navigationTitle("Lista de Compras 📝")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarItems(
            trailing:
                NavigationLink(destination: AddView()) {
                    Image(systemName: "person.fill.badge.plus")
                        .font(.title2)
                }
        )
    }
    
    func makeEmptyView() -> some View {
        VStack {
            Text("Sua lista está vazia")
                .font(.title2)
            NavigationLink(destination: AddView()) {
                Image(systemName: "cart.fill.badge.plus")
                    .font(.largeTitle)
            }
            .padding()
        }
    }
    
}

#Preview {
    NavigationStack {
        GrocerShopListView()
    }
}
