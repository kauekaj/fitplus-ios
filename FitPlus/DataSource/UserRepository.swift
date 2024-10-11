//
//  UserRepository.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 10/10/24.
//

import Foundation

protocol UserRepositoryProtocol: ObservableObject {
    var user: FitPlusUser? { get }
    func saveUser(_ user: FitPlusUser)
    func loadUser()
    func getUser() -> FitPlusUser?
    func clearUser()
}

final class UserRepository: UserRepositoryProtocol {
    @Published var user: FitPlusUser?
    
    func saveUser(_ user: FitPlusUser) {
        self.user = user
        if let encodedUser = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encodedUser, forKey: "savedUser")
        }
    }
    
    func loadUser() {
        if let savedUserData = UserDefaults.standard.data(forKey: "savedUser"),
           let decodedUser = try? JSONDecoder().decode(FitPlusUser.self, from: savedUserData) {
            self.user = decodedUser
        } else {
            self.user = nil
        }
    }
    
    func getUser() -> FitPlusUser? {
        if let currentUser = user {
            return currentUser
        } else {
            loadUser()
            return user
        }
    }
    
    func clearUser() {
        self.user = nil
        UserDefaults.standard.removeObject(forKey: "savedUser")
    }
}

class DependencyAssembly {
    static let shared = DependencyAssembly()

    private init() { }

    func resolveUserRepository() -> any UserRepositoryProtocol {
        let user = UserRepository()
        user.getUser()
        return user
    }
}
