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
    @State var list: ListModel
    @State private var showTrayError: TrayError = .idle
    @State private var showingTray = false
    @State private var newItemName = ""

    init(list: ListModel, viewModel: GrocerShopListViewModel) {
        self.list = list
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
                                        viewModel.toggleItemStatus(listId: list.id, itemId: item.id, isCompleted: !item.isCompleted)
                                    }
                                }
                        }
                        .onDelete { indexSet in
                            viewModel.deleteItem(listId: list.id, indexSet: indexSet)
                        }
                        .onMove(perform: viewModel.moveItem)
                    }
                    .listStyle(PlainListStyle())
                }
            }

            if showingTray {
                makeTray()
            }
            
            makeAddButton()
        }
        .navigationTitle(list.name)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarItems(
            trailing:
                NavigationLink(destination: AddView(listId: list.id)) {
                    Image(systemName: "person.fill.badge.plus")
                        .font(.title2)
                }
        )
        .onFirstAppear {
            viewModel.addListenerForListItems(listId: list.id)
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
    
    func makeTray() -> some View {
        VStack {
            Spacer()

            VStack(spacing: 16) {
                Text("Adicionar nova lista")
                    .font(.headline)

                TextField("Digite o nome da lista aqui...", text: $newItemName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
               
                if showTrayError != .idle {
                    Text(showTrayError.rawValue)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }
                
                HStack {
                    Button("Cancelar") {
                        withAnimation {
                            showingTray.toggle()
                            showTrayError = .idle
                        }
                    }
                    .padding(.horizontal)

                    Button("Salvar") {
                        Task {
                            if !newItemName.isEmpty {
                                try await ListsManager.shared.addItem(listId: list.id, name: newItemName)
                                newItemName = ""
                                showingTray.toggle()
                            } else {
                                showTrayError = .emptyField
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
