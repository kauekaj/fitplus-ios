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
    @State private var showTrayError: trayError = .idle
    @State private var showingTray = false
    @State private var newListName = ""

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                ScrollView {
                    Text("Minhas listas")
                        .font(.largeTitle)
                        .padding(.vertical, 38)
                    
                    
                    ForEach(viewModel.lists) { list in
                        HStack {
                            Text(list.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            Spacer()
                            
                            if list.status == .notStarted {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.title2)
                                    .padding(.trailing, 20)
                            }
                        }
                        .frame(height: 48)
                        .background(Color.accentColor.opacity(0.5))
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 4)
                        .padding(.horizontal, 16)
                        .onTapGesture {
                            path.append(list)
                        }
                        .navigationDestination(for: ListModel.self) { list in
                            GrocerShopListView(list: list, viewModel: GrocerShopListViewModel())
                        }
                    }
                    
                    makeButton()
                }
                
                if showingTray {
                    makeTray()
                }
            }
        }
        .task {
            try? await viewModel.getUserLists()
        }
    }
    
    func makeButton() -> some View {
        Button {
            showingTray.toggle()
        } label: {
            Text("Criar Lista")
        }
        .padding(.vertical, 16)
    }
    
}

extension ListsView {
    
    func makeTray() -> some View {
        VStack {
            Spacer()

            VStack(spacing: 16) {
                Text("Adicionar novo item")
                    .font(.headline)

                TextField("Digite o nome do item aqui...", text: $newListName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
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
                            if !newListName.isEmpty {
                                
                                do {
                                    let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid

                                    try await ListsManager.shared.uploadList(
                                        list: ListModel(
                                            id: "\(UUID())",
                                            authorId: userId,
                                            name: newListName,
                                            type: .toDo,
                                            status: .inProgress
                                        )
                                    )
                                    newListName = ""
                                    showingTray.toggle()
                                } catch {
                                    print("Erro saving List")
                                }
                                
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
}
