//
//  ChangePasswordView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 23/10/24.
//

import SwiftUI

struct ChangePasswordView: View {
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmNewPassword: String = ""
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""
    @State private var toastColor: Color = .clear
    @State private var showForgotPassword = false
    
    @State private var forgotPasswordInputText: String = ""
    @State private var shouldShowTray = false
    @State private var isResetPasswordEmailSent = false
    @State private var isLoading = false
    @State private var dotCount = 0

    @EnvironmentObject var userRepository: UserRepository

    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                Image(systemName: "lock.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.accentColor)
                    .padding(.bottom, 20)
                
                SecureField("Digite sua senha antiga", text: $currentPassword)
                    .modifier(TextFieldModifier())


                SecureField("Digite sua nova senha", text: $newPassword)
                    .modifier(TextFieldModifier())
                
                SecureField("Confirme sua nova senha", text: $confirmNewPassword)
                    .modifier(TextFieldModifier())
                
                Button(action: {
                    withAnimation {
                        isLoading.toggle()
                    }
                    changePassword()
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.accentColor)
                            .frame(height: 48)
                        
                        if isLoading {
                            HStack(spacing:4) {
                                ForEach(0..<3) { index in
                                    Circle()
                                        .frame(width: index == dotCount ? 10 : 7, height: index == dotCount ? 10 : 7)
                                        .foregroundColor(.white)
                                }
                            }
                            .onAppear {
                                startLoadingAnimation()
                            }
                        } else {
                            Text("Alterar senha")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                
                Button(action: {
                    shouldShowTray = true
                }) {
                    Text("Esqueci minha senha")
                        .font(.footnote)
                        .foregroundColor(.accentColor)
                }
              
            }
            .padding()
            
            if showToast {
                makeToast()
                    .transition(.opacity)
            }
            
            if shouldShowTray == true {
                makeTray()
                    .offset(y: (UIScreen.main.bounds.height * 0.30))
            }
        }
    }

    func changePassword() {
        if currentPassword.isEmpty || newPassword.isEmpty {
            showError("Preencha todos os campos!")
            isLoading = false
        } else if newPassword != confirmNewPassword {
            isLoading = false
            showError("As nova senha e a confirmação estão diferentes.")
        } else if newPassword == currentPassword {
            isLoading = false
            showError("A nova senha não pode ser igual à antiga!")
        } else {
            Task {
                do {
                    try await AuthenticationManager.shared.signInUser(email: userRepository.user?.email ?? "", password: currentPassword)
                    
                    try await AuthenticationManager.shared.updatePassword(password: newPassword)
                    isLoading = false
                    currentPassword = ""
                    newPassword = ""
                    confirmNewPassword = ""
                    showSuccess("Senha alterada com sucesso!")
                } catch {
                    isLoading.toggle()
                    showErrorFirebase(error: error.localizedDescription)
                    print("Error updating password \(error.localizedDescription)")
                }
            }
        }
    }
    
    func showErrorFirebase(error: String) {
        switch error {
        case FirebaseError.credentialError.rawValue:
            showError("A senha atual está incorreta.")
        case FirebaseError.passwordError.rawValue:
            showError("A senha deve conter no mímimo 6 caracteres.")
        default:
            showError("Erro ao tentar atualiza a senha. Gentileza tentar mais tarde.")
        }
    }
    enum FirebaseError: String {
        case credentialError = "The supplied auth credential is malformed or has expired."
        case passwordError = "The password must be 6 characters long or more."
    }

    func showSuccess(_ message: String) {
        toastMessage = message
        toastColor = Color(red: 0.8, green: 1.0, blue: 0.8)
        showToast = true
        hideToastAfterDelay()
    }

    func showError(_ message: String) {
        toastMessage = message
        toastColor = Color(red: 1.0, green: 0.8, blue: 0.8)
        showToast = true
        hideToastAfterDelay()
    }

    func hideToastAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation {
                showToast = false
            }
        }
    }

    func startLoadingAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            if !isLoading {
                timer.invalidate()
            } else {
                dotCount = (dotCount + 1) % 3
            }
        }
    }

    @ViewBuilder
    func makeToast() -> some View {
        VStack {
            HStack {
                Text(toastMessage)
                Spacer()
                
                Button(action: {
                    withAnimation {
                        showToast.toggle()
                    }
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(8)
                }
                .background(Circle().fill(Color.gray.opacity(0.4)))
            }
            .foregroundColor(.black)
            .padding(8)
            .background(toastColor)
            .frame(maxWidth: .infinity)
            .cornerRadius(8)
            
            Spacer()
        }
        .padding(.horizontal, 4)
        
    }
    
    func makeTray() -> some View {
        VStack {
            VStack(spacing: 16) {
                
                if isResetPasswordEmailSent == true {
                    
                    Text("Email enviado!")
                    Text("Confira sua caixa de entrada.")

                    Button("OK") {
                        withAnimation {
                            shouldShowTray.toggle()
                            isResetPasswordEmailSent.toggle()
                        }
                    }
                    .padding(.horizontal)
                } else {
                    Text("Resetar Senha")
                        .font(.headline)

                    TextField("Email cadastrado", text: $forgotPasswordInputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    HStack {
                        Button("Cancelar") {
                            withAnimation {
                                shouldShowTray.toggle()
                            }
                        }
                        .padding(.horizontal)

                        Button("Enviar") {
                            Task {
                                try await AuthenticationManager.shared.resetPassword(email: forgotPasswordInputText)
                                isResetPasswordEmailSent.toggle()
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(radius: 8)
            .frame(maxWidth: .infinity)
            .transition(.move(edge: .top))
            
            Spacer()
        }
        .zIndex(2)
        .padding()
        .animation(.easeInOut, value: shouldShowTray)
    }
}

