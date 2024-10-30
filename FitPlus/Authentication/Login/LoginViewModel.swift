//
//  LoginViewModel.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 26/07/24.
//

import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    
    @Published var showToast: Bool = false
    @Published var toastMessage: String = ""
    @Published var toastType: ToastType = .success
    
    func signIn(email: String, password: String) async throws {
        do {
            try await AuthenticationManager.shared.signInUser(email: email, password: password)
        } catch  {
            configToast(type: .error, message: "Login ou senha incorretos.")
            print("Falha ao logar \(error)")
        }
    }
    
    func validateFields(email: String, password: String) -> Bool {
        switch (email.isEmpty, password.isEmpty) {
        case (true, true):
            configToast(type: .error, message: "Preencher email e senha")
            return false
        case (true, false):
            configToast(type: .error, message: "Preencher email")
            return false
        case (false, true):
            configToast(type: .error, message: "Preencher senha")
            return false
        default:
            return true
        }
    }
    
    func configToast(type: ToastType, message: String) {
        toastType = type
        toastMessage = message
        showToast = true
    }

}
