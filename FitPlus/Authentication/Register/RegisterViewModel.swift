//
//  RegisterViewModel.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 26/07/24.
//

import SwiftUI

@MainActor
final class RegisterViewModel: ObservableObject {
    
    @Published var showToast: Bool = false
    @Published var toastMessage: String = ""
    @Published var toastType: ToastType = .success
    
    func signUp(email: String, password: String, confirmedPassword: String) async throws {
        
        do {
            let authDataresult = try await AuthenticationManager.shared.createUser(email: email, password: password)
            let user = FitPlusUser(auth: authDataresult)
            try await UserManager.shared.createNewUser(user: user)
        } catch  {
            showErrorFirebase(error: error.localizedDescription)
            print("Falha ao logar \(error)")
        }
        
    }
    
    func showErrorFirebase(error: String) {
        switch error {
        case FirebaseError.emailAlreadyUsedError.rawValue:
            configToast(type: .error, message: "O email já está sendo usado por outra conta.")
        case FirebaseError.passwordError.rawValue:
            configToast(type: .error, message: "A senha deve conter no mímimo 6 caracteres.")
        default:
            configToast(type: .error, message: "Não foi possível criar um usuário.")
        }
    }
    
    func checkPassword(password: String, confirmedPassword: String) -> Bool {
        password == confirmedPassword ? true : false
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func validateFields(email: String, password: String, confirmedPassword: String) -> Bool {
        switch (email.isEmpty, password.isEmpty, confirmedPassword.isEmpty) {
        case (true, true, true):
            configToast(type: .error, message: ToastError.fillOutEveryField.rawValue)
            return false
        case (true, false, false):
            configToast(type: .error, message: "Preencher email")
            return false
        case (false, true, false):
            configToast(type: .error, message: "Preencher senha")
            return false
        case (false, false, true):
            configToast(type: .error, message: "Preencher confirmação de senha")
            return false
        default:
            break
        }
        
        if !isValidEmail(email) {
            configToast(type: .error, message: ToastError.invalidEmail.rawValue)
            return false
        }
        
        if !checkPassword(password: password, confirmedPassword: confirmedPassword) {
            configToast(type: .error, message: ToastError.passwordDoesNotMatch.rawValue)
            return false
        }
        
        return true
    }
    
    func configToast(type: ToastType, message: String) {
        toastType = type
        toastMessage = message
        showToast = true
    }
}
