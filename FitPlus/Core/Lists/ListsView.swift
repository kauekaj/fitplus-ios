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
    func getUserLists() async throws {
        let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
        lists = try await ListsManager.shared.getUserLists(userId: userId).lists
    }
    
}

struct ListsView: View {
    
    @StateObject var viewModel = ListsViewModel()
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
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: 2)
                    .onTapGesture {
                        path.append(list)
                    }
                    .navigationDestination(for: ListModel.self) { list in
                        GrocerShopListView(listId: list.id, viewModel: GrocerShopListViewModel())
                    }
                }
                
                
                makeButton()
                    .padding(.vertical, 16)
            }
        }
        .task {
            try? await viewModel.getUserLists()
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
            let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid

            try await ListsManager.shared.uploadList(
                list: ListModel(
                    id: "\(UUID())",
                    authorId: userId,
                    name: "list3",
                    type: .toDo,
                    status: .inProgress
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
