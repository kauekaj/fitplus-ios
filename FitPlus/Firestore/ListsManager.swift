//
//  ListsManager.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 21/09/24.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

enum ListStatus: Codable {
    case notStarted
    case inProgress
    case completed
    case canceled
    case onHold
}

enum ListType: Codable {
    case grocerList
    case toDoList
}

struct ListModel: Codable, Identifiable, Hashable, Equatable {
    let id: String
    let authorId: String?
    let name: String?
    let type: ListType?
    let status: ListStatus?
    let isShared: Bool?
    
    init(
        id: String,
        authorId: String,
        name: String,
        type: ListType,
        status: ListStatus,
        isShared: Bool
    ) {
        self.id = id
        self.authorId = authorId
        self.name = name
        self.type = type
        self.status = status
        self.isShared = isShared
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case authorId = "author_id"
        case name
        case type
        case status
        case isShared = "is_shared"
    }
}

final class ListsManager {
    
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
    
    func deleteList(listId: String) async throws {
        try await listDocument(listId: listId).delete()
    }
    
    func getAllUserLists() async throws -> [ListModel] {
        try await listsCollection.getDocuments(as: ListModel.self)
    }
    
    func getUserLists(userId: String) async throws -> (lists: [ListModel], lastDocument: DocumentSnapshot?) {
        return try await listsCollection
            .whereField(ListModel.CodingKeys.authorId.rawValue, isEqualTo: userId)
            .getDocumentsWithSnapshot(as: ListModel.self)
    }
    
    private var listItemsListener: ListenerRegistration? = nil
    
    func getItems(listId: String) async throws -> [ItemModel] {
        try await itemsCollection(listId: listId).getDocuments(as: ItemModel.self)
    }
    
    func getItem(listId: String, itemId: String) async throws -> ItemModel {
        try await itemDocument(listId: listId, itemId: itemId).getDocument(as: ItemModel.self)
    }
    
    private func itemsCollection(listId: String) -> CollectionReference {
        listDocument(listId: listId).collection("items")
    }
    
    private func itemDocument(listId: String, itemId: String) -> DocumentReference {
        itemsCollection(listId: listId).document(itemId)
    }
    
    func addItem(listId: String, name: String) async throws {
        let document = itemsCollection(listId: listId).document()
        let documentId = document.documentID
        
        let data: [String:Any] = [
            ItemModel.CodingKeys.id.rawValue : documentId,
            ItemModel.CodingKeys.listId.rawValue : listId,
            ItemModel.CodingKeys.dateCreated.rawValue : Timestamp(),
            ItemModel.CodingKeys.title.rawValue : name,
            ItemModel.CodingKeys.isCompleted.rawValue : false
        ]
        
        try await document.setData(data, merge: false)
    }
    
    func updateItemStatus(listId: String, itemId: String, iscompleted: Bool) async throws {
        let data: [String:Any] = [
            ItemModel.CodingKeys.isCompleted.rawValue : iscompleted
        ]
        
        try await itemDocument(listId: listId, itemId: itemId).updateData(data)
    }
    
    func removeListItem(listId: String, itemId: String) async throws {
        try await itemDocument(listId: listId, itemId: itemId).delete()
    }
        
    func removeListenerForAllUserFavoriteProducts() {
        self.listItemsListener?.remove()
    }
    
    func addListenerForListItems(listId: String) -> AnyPublisher<[ItemModel], Error> {
        let (publisher, listener): (AnyPublisher<[ItemModel], Error>, ListenerRegistration) = itemsCollection(listId: listId)
            .addSnapshotListener(as: ItemModel.self)
        
        self.listItemsListener = listener
        return publisher
    }
}
