//
//  LoginViewModel.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 26/07/24.
//

import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    
    func signIn(email: String, password: String) async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return
        }
        
        do {
            try await AuthenticationManager.shared.signInUser(email: email, password: password)
        } catch  {
            print("Falha ao logar \(error)")
        }
    }

}
