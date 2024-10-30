//
//  UserRepository.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 10/10/24.
//


import SwiftUI

protocol UserRepositoryProtocol: ObservableObject {
    var user: FitPlusUser? { get }
    func cacheUser(_ user: FitPlusUser)
    func loadCachedUser()
    func loadUserFromAPI() async throws
    func getUser() -> FitPlusUser?
    func clearUser()
    func updateUser() async throws
}

final class UserRepository: UserRepositoryProtocol {
    @Published var user: FitPlusUser?
    
    @MainActor
    func loadUserFromAPI() async throws{
        do {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            
            self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
            if let user = user {
                cacheUser(user)
            }
        } catch {
            print("Erro ao carregar o usuário: \(error)")
        }
    }
    
    @MainActor
    func cacheUser(_ user: FitPlusUser) {
        self.user = user
        if let encodedUser = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encodedUser, forKey: "savedUser")
        }
    }
    
    func updateUser() async throws {
        try await loadUserFromAPI()
    }
    
    @MainActor
    func loadCachedUser() {
        if let savedUserData = UserDefaults.standard.data(forKey: "savedUser"),
           let decodedUser = try? JSONDecoder().decode(FitPlusUser.self, from: savedUserData) {
            self.user = user
        } else {
            self.user = nil
        }
    }
    
    func getUser() -> FitPlusUser? {
        if let currentUser = user {
            return currentUser
        } else {
            Task { @MainActor in
                loadCachedUser()
            }
            return user
        }
    }
    
    func clearUser() {
        Task { @MainActor in
            self.user = nil
        }
        UserDefaults.standard.removeObject(forKey: "savedUser")
    }
}
