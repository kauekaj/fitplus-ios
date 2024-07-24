//
//  ListView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 21/07/24.
//

//import SwiftUI
//
//struct ListView: View {
//    var body: some View {
//        
//        
//        NavigationLink {
//            GrocerShopListView()
////                .navigationBarBackButtonHidden()
//        } label:  {
//                Text("Ir para lista de compras")
//                    .foregroundStyle(.black)
//        }
//    }
//}

import SwiftUI

struct ListView: View {
    @StateObject var viewModel = GrocerShopListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.mockItems) { item in
                        NavigationLink(destination: GrocerShopListView()) {
                            HStack {
                                Text(item.title)
                                Spacer()
                                if item.isCompleted {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                    .navigationTitle("Minhas listas")
                }
            }
            
        }
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
    ListView()
}
