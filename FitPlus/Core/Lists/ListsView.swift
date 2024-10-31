//
//  ListsView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 21/07/24.
//

import SwiftUI

struct ListsView: View {
    
    @StateObject var viewModel = ListsViewModel()
    @State private var path = NavigationPath()
    @State private var showTrayError: ToastError = .idle
    @State private var showingTray = false
    @State private var newListName = ""
    @State private var showDeleteConfirmation = false
    @State private var listToDelete: ListModel?

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                ScrollView {
                    Text("Minhas listas")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    
                    makeLists()
                    
                    makeButton()
                }
                
                if showingTray {
                    makeTray()
                }
            }
            .alert(isPresented: $showDeleteConfirmation) {
                Alert(
                    title: Text("Excluir Lista"),
                    message: Text("Tem certeza de que deseja excluir esta lista?"),
                    primaryButton: .destructive(Text("Excluir")) {
                        if let list = listToDelete {
                            Task {
                                do {
                                    try await viewModel.deleteList(list)
                                    listToDelete = nil
                                } catch {
                                    print("Erro ao excluir a lista")
                                }
                            }
                        }
                    },
                    secondaryButton: .cancel(Text("Cancelar"))
                )
            }
        }
        .task {
            try? await viewModel.getUserLists()
        }
    }
    
    func makeButton() -> some View {
        Button(action: {
            withAnimation {
                showingTray = true
            }
        }) {
            Text("Criar Lista")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .cornerRadius(12)
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
}

extension ListsView {
    
    func makeLists() -> some View {
        ForEach(viewModel.lists) { list in
            ListCardView(list: list) {
                listToDelete = list
                showDeleteConfirmation.toggle()
            } onTap: {
                path.append(list)
            }
            .navigationDestination(for: ListModel.self) { list in
                GrocerShopListView(list: list, viewModel: GrocerShopListViewModel())
                    .navigationBarHidden(true)
            }
        }
    }
    
    func makeTray() -> some View {
        VStack {
            Spacer()

            VStack(spacing: 16) {
                Text("Adicionar nova lista")
                    .font(.headline)

                TextField("Nome da lista...", text: $newListName)
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
                            if !newListName.isEmpty {
                                
                                do {
                                    let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid

                                    try await ListsManager.shared.uploadList(
                                        list: ListModel(
                                            id: "\(UUID())",
                                            authorId: userId,
                                            name: newListName,
                                            type: .grocerList,
                                            status: .notStarted,
                                            isShared: false
                                        )
                                    )
                                    
                                    try await viewModel.getUserLists()
                                    
                                    newListName = ""
                                    showingTray.toggle()
                                } catch {
                                    print("Erro ao salvar lista")
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
