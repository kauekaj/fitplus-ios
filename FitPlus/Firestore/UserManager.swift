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
    let email: String?
    let fullName: String?
    let userName: String?
    let profileImagePath: String?
    let profileImagePathUrl: String?
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.email = auth.email
        self.fullName = nil
        self.userName = nil
        self.profileImagePath = nil
        self.profileImagePathUrl = nil
    }
    
    init(
        userId: String,
        email: String? = nil,
        fullName: String? = nil,
        userName: String? = nil,
        profileImagePath: String? = nil,
        profileImagePathUrl: String?  = nil
    ) {
        self.userId = userId
        self.email = email
        self.fullName = fullName
        self.userName = userName
        self.profileImagePath = profileImagePath
        self.profileImagePathUrl = profileImagePathUrl
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email = "email"
        case fullName = "full_name"
        case userName = "user_name"
        case profileImagePath = "profile_image_path"
        case profileImagePathUrl = "profile_image_path_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.fullName = try container.decodeIfPresent(String.self, forKey: .fullName)
        self.userName = try container.decodeIfPresent(String.self, forKey: .userName)
        self.profileImagePath = try container.decodeIfPresent(String.self, forKey: .profileImagePath)
        self.profileImagePathUrl = try container.decodeIfPresent(String.self, forKey: .profileImagePathUrl)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.fullName, forKey: .fullName)
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
    
    func updateUserFullName(userId: String, fullName: String) async throws {
        let data: [String:Any] = [
            FitPlusUser.CodingKeys.fullName.rawValue : fullName
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func updateUserData(userId: String, field: String, value: String) async throws {
        var data: [String:Any] = [:]
        
        if field == FitPlusUser.CodingKeys.fullName.rawValue {
            data[FitPlusUser.CodingKeys.fullName.rawValue] = value
        }
        
        if field == FitPlusUser.CodingKeys.email.rawValue {
            data[FitPlusUser.CodingKeys.email.rawValue] = value
        }
        
        if field == FitPlusUser.CodingKeys.userName.rawValue {
            data[FitPlusUser.CodingKeys.userName.rawValue] = value
        }
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func deleteUserFirestoreData(userId: String) async throws {
        try await userDocument(userId: userId).delete()
    }
}
