//
//  RegisterViewModel.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 26/07/24.
//

import SwiftUI

@MainActor
final class RegisterViewModel: ObservableObject {
    
    func signUp(fullName: String, email: String, password: String, confirmedPassword: String) async throws {
        if !checkPassword(password: password, confirmedPassword: confirmedPassword) {
            print("Password doesn't match")
            return
        }
        
        let authDataresult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        let user = FitPlusUser(auth: authDataresult)
        try await UserManager.shared.createNewUser(user: user)
        
        try await UserManager.shared.updateUserFullName(userId: user.userId, fullName: fullName)
    }
    
    func checkPassword(password: String, confirmedPassword: String) -> Bool {
        password == confirmedPassword ? true : false
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
