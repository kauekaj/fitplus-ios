//
//  ListsView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 21/07/24.
//

import SwiftUI

final class ListsViewModel: ObservableObject {
    
    @Published private(set) var lists: [ListModel] = []
    
    @MainActor
    func getAllLists() async throws {
        lists = try await ListsManager.shared.getAllUserLists()
    }
    
    // Excluir
    @Published var listMockTest: [ListModel] = [
        ListModel(id: "99999", name: "test", type: .grocerShop, status: .notStarted, items: [ItemModel(title: "First item", isCompleted: false)]),
        ListModel(id: "99998", name: "test2", type: .grocerShop, status: .notStarted, items: [ItemModel(title: "First item", isCompleted: true)]),
        ListModel(id: "99997", name: "test3", type: .toDo, status: .notStarted,  items: [ItemModel(title: "First item", isCompleted: false)])
    ]
    
}



struct ListsView: View {
    @StateObject var viewModel = ListsViewModel()
        
    @State private var goToList: Bool = false
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                Text("Minhas listas")
                    .font(.largeTitle)
                    .padding(.vertical, 38)
                
                
                ForEach(viewModel.lists) { list in
                    HStack {
                        Spacer()
                        Text(list.name)
                        Spacer()
                        if list.status == .notStarted {
                            Image(systemName: "checkmark")
                        }
                    }
                    .frame(height: 36)
                    .background(Color.accentColor)
                    .padding(.horizontal, 24)
                    .onTapGesture {
                        path.append(list)
                    }
                    .navigationDestination(for: ListModel.self) { _ in
                        GrocerShopListView(viewModel: GrocerShopListViewModel())
                    }
                }
                
                
                makeButton()
                    .padding(.vertical, 16)
            }
        }
        .task {
            try? await viewModel.getAllLists()
        }
    }
    
    func makeButton() -> some View {
        Button {
            Task {
                try await add()
            }
        } label: {
            Text("Criar Lista")
        }
    }
    
    func add() async throws {
        do {
            try await ListsManager.shared.uploadList(
                list: ListModel(
                    id: "Teste3",
                    name: "listTest",
                    type: .toDo,
                    status: .inProgress,
                    items: [ItemModel(
                        id: "99",
                        title: "test",
                        isCompleted: false
                    )]
                )
            )
        } catch {
            print("Erro saving List")
        }
    }
}

#Preview {
    ListsView()
}
