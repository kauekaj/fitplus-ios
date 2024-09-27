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
    let authorId: String
    let name: String
    let type: ListType
    let status: ListStatus
//    let items: [ItemModel]
    
    init(
        id: String,
        authorId: String,
        name: String,
        type: ListType,
        status: ListStatus
//        items: [ItemModel]
    ) {
        self.id = id
        self.authorId = authorId
        self.name = name
        self.type = type
        self.status = status
//        self.items = items
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case authorId = "author_id"
        case name
        case type
        case status
//        case items
    }
}

final class ListsManager {
    
    // Remover este Singleton após o teste
    static let shared = ListsManager()
    private init() { }
    
    private let listsCollection: CollectionReference = Firestore.firestore().collection("lists")

    private func listDocument(listId: String) -> DocumentReference {
        listsCollection.document(listId)
    }
    
    func uploadList(list: ListModel) async throws {
        try listDocument(listId: list.id).setData(from: list, merge: false)
    }
    
    func getList(listId: String) async throws -> ListModel {
        try await listDocument(listId: listId).getDocument(as: ListModel.self)
    }
    
    func getAllUserLists() async throws -> [ListModel] {
        try await listsCollection.getDocuments(as: ListModel.self)
    }
    
    func getUserLists(userId: String) async throws -> (lists: [ListModel], lastDocument: DocumentSnapshot?) {
        return try await listsCollection
            .whereField(ListModel.CodingKeys.authorId.rawValue, isEqualTo: userId)
            .getDocumentsWithSnapshot(as: ListModel.self)
    }
    
    func getItems(listId: String) async throws -> [ItemModel] {
        try await itemsCollection(listId: listId).getDocuments(as: ItemModel.self)
    }
    
    func getItem(listId: String, itemId: String) async throws -> ItemModel {
        try await itemDocument(listId: listId, itemId: itemId).getDocument(as: ItemModel.self)
    }
    
    private func itemsCollection(listId: String) -> CollectionReference {
//        listsCollection.document(listId).collection("items")
        listDocument(listId: listId).collection("items")
    }
    
    private func itemDocument(listId: String, itemId: String) -> DocumentReference {
        itemsCollection(listId: listId).document(itemId)
    }
    
    func addItem(listId: String) async throws {
        let document = itemsCollection(listId: listId).document()
        let documentId = document.documentID
        
        let data: [String:Any] = [
            "id" : documentId,
            "list_id": listId,
            "date" : Timestamp(),
            "title": "teste",
            "is_completed": false
        ]
        
        try await document.setData(data, merge: false)
    }
}
