//
//  UserNameManager.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 28/10/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

final class UserNameManager {
    
    static let shared = UserNameManager()
    private init() { }
    
    private let userNameCollection: CollectionReference = Firestore.firestore().collection("userNames")
    
    private func userNameDocument(username: String) -> DocumentReference {
        userNameCollection.document(username.lowercased())
    }
    
    private func isUserNameAvailable(_ userName: String) async throws -> Bool {
        let document = userNameDocument(username: userName)
        let snapshot = try await document.getDocument()
        
        return !snapshot.exists
    }
    
    func addUserName(_ userName: String, userId: String) async throws {
        let document = userNameCollection.document(userName.lowercased())
        
        let isAvailable = try await isUserNameAvailable(userName)
        guard isAvailable else {
            throw NSError(domain: "UserName already taken", code: 400, userInfo: nil)
        }
        
        let data: [String: Any] = [
            "userId": userId
        ]
        
        try await document.setData(data, merge: false)
    }
    
    private func removeUserName(_ userName: String) async throws {
        let document = userNameCollection.document(userName.lowercased())
        try await document.delete()
    }
    
    func updateUserName(newUserName: String, userId: String) async throws {
        let oldUserName = try await getUserName(userId: userId)
        
        let isAvailable = try await isUserNameAvailable(newUserName)
        guard isAvailable else {
            throw NSError(domain: "UserName already taken", code: 400, userInfo: nil)
        }
        
        if oldUserName != nil {
            try await removeUserName(oldUserName ?? "")
        }
        
        try await addUserName(newUserName, userId: userId)
    }
    
    func getUserName(userId: String) async throws -> String? {
        let querySnapshot = try await userNameCollection.whereField("userId", isEqualTo: userId).getDocuments()
        
        guard let document = querySnapshot.documents.first else {
            return nil
        }
        
        return document.documentID
    }
}
