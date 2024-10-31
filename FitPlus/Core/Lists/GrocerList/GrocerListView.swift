//
//  GrocerListView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 20/07/24.
//

import Combine
import SwiftUI

struct GrocerListView: View {
    
    @ObservedObject var viewModel: GrocerListViewModel
    @State var list: ListModel
    @State private var showTrayError: ToastError = .idle
    @State private var showingTray = false
    @State private var newItemName = ""
    
    init(list: ListModel, viewModel: GrocerListViewModel) {
        self.list = list
        self.viewModel = viewModel
    }
    
    var body: some View {
        DSMCustomNavigationBar(title: "\(list.name ?? "")") {
            AnyView(
                ZStack {
                    if viewModel.items.isEmpty {
                        makeEmptyView()
                    } else {
                        VStack {
                            List {
                                ForEach(viewModel.items) { item in
                                    ItemRowView(item: item)
                                        .onTapGesture {
                                            withAnimation(.linear) {
                                                viewModel.toggleItemStatus(listId: list.id , itemId: item.id, isCompleted: !(item.isCompleted ?? false))
                                            }
                                        }
                                }
                                .onDelete { indexSet in
                                    viewModel.deleteItem(listId: list.id , indexSet: indexSet)
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
                .onFirstAppear {
                    viewModel.addListenerForListItems(listId: list.id)
                }
            )
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
                    .font(.system(size: 48))
                    .imageScale(.large)
            }
            .padding()
        }
    }
    
    func makeTray() -> some View {
        VStack {
            Spacer()

            VStack(spacing: 16) {
                Text("Adicionar novo item")
                    .font(.headline)

                TextField("Digite o nome da item aqui...", text: $newItemName)
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
                        showingTray = true
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
