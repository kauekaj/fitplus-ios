//
//  AuthenticationManager.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 23/07/24.
//

import FirebaseAuth
import Foundation

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

enum AuthProviderOption: String {
    case email = "password"
    case google = "google.com"
    case apple = "apple.com"
}

final class AuthenticationManager {
    
    // MARK: - TODO -> Remove Singleton and use DI
    static let shared = AuthenticationManager()
    
    @Published var userSession: FirebaseAuth.User?

    private init() {
        DispatchQueue.main.async {
            self.userSession = Auth.auth().currentUser
        }
    }
        
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
    
    func getProviders() throws -> [AuthProviderOption] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        
        var providers: [AuthProviderOption] = []
        for provider in providerData {
            if let option = AuthProviderOption(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                assertionFailure("Provider option not found: \(provider.providerID)")
            }
        }
        
        return providers
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        self.userSession = nil
    }
    
    func delete() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        
        try await user.delete()
    }
}

// MARK: SIGN IN EMAIL

extension AuthenticationManager {
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let dataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        self.userSession = dataResult.user
        print("DEBUG: Created user \(dataResult.user.uid)")
        return AuthDataResultModel(user: dataResult.user)
//        do {
//            let dataResult = try await Auth.auth().createUser(withEmail: email, password: password)
//            self.userSession = dataResult.user
//            print("DEBUG: Created user \(dataResult.user.uid)")
//            return AuthDataResultModel(user: dataResult.user)
//        } catch {
//            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
//        }
    }
    
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        self.userSession = authDataResult.user
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        try await user.updatePassword(to: password)
    }
    
    func updateEmail(email: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        do {
            try await user.sendEmailVerification(beforeUpdatingEmail: email)
        } catch  {
            print(error)
        }

    }
}
