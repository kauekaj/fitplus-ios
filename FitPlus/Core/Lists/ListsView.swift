//
//  ListsView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 21/07/24.
//

import SwiftUI

enum ListStatus {
    case notStarted
    case inProgress
    case completed
    case canceled
    case onHold
}

enum ListType {
    case grocerShop
    case toDo
}

struct ListModel: Identifiable, Hashable, Equatable {
    let id: String
    let name: String
    let type: ListType
    let status: ListStatus
    let items: [ItemModel]
    
    init(id: String, name: String, type: ListType, status: ListStatus, items: [ItemModel]) {
        self.id = id
        self.name = name
        self.type = type
        self.status = status
        self.items = items
    }
}

final class ListsViewModel: ObservableObject {
    
    @Published var listMockTest: [ListModel] = [
        ListModel(id: "99999", name: "test", type: .grocerShop, status: .notStarted, items: [ItemModel(title: "First item", isCompleted: false)]),
        ListModel(id: "99998", name: "test2", type: .grocerShop, status: .notStarted, items: [ItemModel(title: "First item", isCompleted: true)]),
        ListModel(id: "99997", name: "test3", type: .toDo, status: .notStarted,  items: [ItemModel(title: "First item", isCompleted: false)])
    ]
}



struct ListsView: View {
    @StateObject var viewModel = ListsViewModel()
    
    let coordinator =  ListsCoordinator(rootViewController: UINavigationController())
    
    @State private var goToList: Bool = false
    
    @State private var path = NavigationPath()

    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                Text("Minhas listas")
                    .font(.largeTitle)
                    .padding(.vertical, 38)
                
                
                ForEach(viewModel.listMockTest) { list in
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
    }
    
    func makeButton() -> some View {
        Button {
            add()
        } label: {
            Text("Criar Lista")
        }
    }
    
    func add() {
//        viewModel.mockItems.remove(at: 1)
    }
}

import SwiftUI

class ListViewModel: ObservableObject {
    @Published var sharedItems: [ItemModel2] = [
        ItemModel2(title: "Shared Item 1", isCompleted: false),
        ItemModel2(title: "Shared Item 2", isCompleted: true)
    ]
    
    @Published var nonSharedItems: [ItemModel2] = [
        ItemModel2(title: "Non-Shared Item 1", isCompleted: false),
        ItemModel2(title: "Non-Shared Item 2", isCompleted: true)
    ]
}

struct ItemModel2: Identifiable {
    let id = UUID()
    let title: String
    var isCompleted: Bool
}

import SwiftUI

struct DetailView: View {
    var item: ItemModel2
    
    var body: some View {
        VStack {
            Text(item.title)
                .font(.largeTitle)
                .padding()
            
            if item.isCompleted {
                Text("This item is completed.")
                    .foregroundColor(.green)
            } else {
                Text("This item is not completed.")
                    .foregroundColor(.red)
            }
        }
        .navigationTitle("Nome da lista")
    }
}

#Preview {
    ListsView()
}
