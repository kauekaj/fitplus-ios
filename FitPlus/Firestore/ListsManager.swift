//
//  ListsManager.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 21/09/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

enum ListStatus: Codable {
    case notStarted
    case inProgress
    case completed
    case canceled
    case onHold
}

enum ListType: Codable {
    case grocerShop
    case toDo
}

struct ListModel: Codable, Identifiable, Hashable, Equatable {
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

final class ListsManager {
    
    // Remover este Singleton após o teste
    static let shared = ListsManager()
    private init() { }
    
    private let listsCollection = Firestore.firestore().collection("lists")

    private func listDocument(listId: String) -> DocumentReference {
        listsCollection.document(listId)
    }
    
    func uploadList(list: ListModel) async throws {
        try listDocument(listId: list.id).setData(from: list, merge: false)
    }
    
    func getAllUserLists() async throws -> [ListModel] {
        
        // Configurar a chamada para trazer apenas as listas que o usuário criou ou então foi compartilhada com ele.
        
//        let snapshot = try await listsCollection.getDocuments().query.whereField("id", arrayContains: "kajId")
        let snapshot = try await listsCollection.getDocuments()
        print("kaj snapshot \(snapshot)")
        var lists: [ListModel] = []
        
        for document in snapshot.documents {
            let list = try document.data(as: ListModel.self)
            lists.append(list)
            print(list)
        }
        
        return lists
    }
}
