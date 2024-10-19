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
    
    func cacheUser(_ user: FitPlusUser) {
        self.user = user
        if let encodedUser = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encodedUser, forKey: "savedUser")
        }
    }
    
    func updateUser() async throws {
        try await loadUserFromAPI()
    }
    
    func loadCachedUser() {
        if let savedUserData = UserDefaults.standard.data(forKey: "savedUser"),
           let decodedUser = try? JSONDecoder().decode(FitPlusUser.self, from: savedUserData) {
            DispatchQueue.main.async {
                self.user = decodedUser
            }
        } else {
            DispatchQueue.main.async {
                self.user = nil
            }
        }
    }
    
    func getUser() -> FitPlusUser? {
        if let currentUser = user {
            return currentUser
        } else {
            loadCachedUser()
            return user
        }
    }
    
    func clearUser() {
        self.user = nil
        UserDefaults.standard.removeObject(forKey: "savedUser")
    }
}
