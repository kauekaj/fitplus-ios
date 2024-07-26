//
//  RegisterViewModel.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 26/07/24.
//

import SwiftUI

@MainActor
final class RegisterViewModel: ObservableObject {
 
    func signUp(email: String, password: String, confirmedPassword: String) async throws {
        if !checkPassword(password: password, confirmedPassword: confirmedPassword) {
            print("Password doesn't match")
            return
        }
        
        let authDataresult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        print(authDataresult)
//        let user = DBUser(auth: authDataresult)
//        try await UserManager.shared.createNewUser(user: user)
    }
    
    func checkPassword(password: String, confirmedPassword: String) -> Bool {
        password == confirmedPassword ? true : false
    }
}
