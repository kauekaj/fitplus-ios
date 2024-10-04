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
    let item: ItemModel

    var body: some View {
        ListRowView(item: item)
    }
}

struct GrocerShopListView: View {
    
    @ObservedObject var viewModel: GrocerShopListViewModel
    @State var listId: String = ""
    @State private var showingTray = false
    @State private var newItemName = ""

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
                    List {
                        ForEach(viewModel.items) { item in
                            ItemCellViewBuilder(item: item)
                                .onTapGesture {
                                    withAnimation(.linear) {
                                        viewModel.toggleItemStatus(listId: listId, itemId: item.id, isCompleted: !item.isCompleted)
                                    }
                                }
                        }
                        .onDelete { indexSet in
                            viewModel.deleteItem(listId: listId, indexSet: indexSet)
                        }
                        .onMove(perform: viewModel.moveItem)
                    }
                    .listStyle(PlainListStyle())
                }
            }

            if showingTray {
                VStack {
                    Spacer()

                    VStack(spacing: 16) {
                        Text("Adicionar novo item")
                            .font(.headline)

                        TextField("Nome do item", text: $newItemName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        HStack {
                            Button("Cancelar") {
                                withAnimation {
                                    showingTray.toggle()
                                }
                            }
                            .padding(.horizontal)

                            Button("Salvar") {
                                Task {
                                    if !newItemName.isEmpty {
                                        try await ListsManager.shared.addItem(listId: listId, name: newItemName)
                                        newItemName = ""
                                        showingTray.toggle()
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(radius: 10)
                    .frame(maxWidth: .infinity)
                    .transition(.move(edge: .bottom))
                    
                    Spacer()
                }
                .padding()
                .animation(.easeInOut, value: showingTray)
            }
            
            makeAddButton()
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
                withAnimation {
                    showingTray.toggle()
                }
            } label: {
                Image(systemName: "cart.fill.badge.plus")
                    .font(.largeTitle)
            }
            .padding()
        }
    }
    
    func makeAddButton() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        showingTray.toggle()
                    }
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                        .padding()
                        .background(Color.accentColor)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .padding()
            }
        }
    }
}


#Preview {
    NavigationStack {
        GrocerShopListView(listId: "123", viewModel: GrocerShopListViewModel())
    }
}
