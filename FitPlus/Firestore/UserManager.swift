//
//  UserManager.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 24/07/24.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation


struct FitPlusUser: Codable {
    let userId: String
    let fullName: String?
    let email: String?
    let userName: String?
    let profileImagePath: String?
    let profileImagePathUrl: String?
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.fullName = auth.fullName
        self.userName = auth.userName
        self.email = auth.email
        self.profileImagePath = nil
        self.profileImagePathUrl = nil
    }
    
    init(
        userId: String,
        fullName: String? = nil,
        email: String? = nil,
        userName: String? = nil,
        profileImagePath: String? = nil,
        profileImagePathUrl: String?  = nil
    ) {
        self.userId = userId
        self.fullName = fullName
        self.email = email
        self.userName = userName
        self.profileImagePath = profileImagePath
        self.profileImagePathUrl = profileImagePathUrl
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case fullName = "full_name"
        case email = "email"
        case userName = "user_name"
        case profileImagePath = "profile_image_path"
        case profileImagePathUrl = "profile_image_path_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.fullName = try container.decodeIfPresent(String.self, forKey: .fullName)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.userName = try container.decodeIfPresent(String.self, forKey: .userName)
        self.profileImagePath = try container.decodeIfPresent(String.self, forKey: .profileImagePath)
        self.profileImagePathUrl = try container.decodeIfPresent(String.self, forKey: .profileImagePathUrl)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.fullName, forKey: .fullName)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.userName, forKey: .userName)
        try container.encodeIfPresent(self.profileImagePath, forKey: .profileImagePath)
        try container.encodeIfPresent(self.profileImagePathUrl, forKey: .profileImagePathUrl)
    }
}

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        return encoder
    }()
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        return decoder
    }()
    
//    private var userFavoriteProductsListener: ListenerRegistration? = nil
    
    func createNewUser(user: FitPlusUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }

    func getUser(userId: String) async throws -> FitPlusUser {
        try await userDocument(userId: userId).getDocument(as: FitPlusUser.self)
    }
    
    func updateUserProfileImagePath(userId: String, path: String?, url: String?) async throws {
        let data: [String:Any] = [
            FitPlusUser.CodingKeys.profileImagePath.rawValue : path ?? NSNull(),
            FitPlusUser.CodingKeys.profileImagePathUrl.rawValue : url ?? NSNull()
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    }
