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
    @State private var toastType: ToastType = .success
    @State private var showForgotPassword = false
    @State private var forgotPasswordInputText: String = ""
    @State private var shouldShowTray = false
    @State private var isResetPasswordEmailSent = false
    @State private var buttonState: ButtonState = .idle

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
                
                DSMButton(title: "Alterar senha", state: $buttonState) {
                    changePassword()
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
                DSMToast(
                    message: toastMessage,
                    type: toastType,
                    autoDismiss: true
                ) {
                    showToast = false
                }
            }
            
            if shouldShowTray == true {
                makeTray()
                    .offset(y: (UIScreen.main.bounds.height * 0.30))
            }
        }
    }

    func changePassword() {
        if currentPassword.isEmpty || newPassword.isEmpty {
            configToast(type: .warning, message: "Preencha todos os campos!")
            buttonState = .idle
        } else if newPassword != confirmNewPassword {
            buttonState = .idle
            configToast(type: .error, message: "As nova senha e a confirmação estão diferentes.")
        } else if newPassword == currentPassword {
            buttonState = .idle
            configToast(type: .error, message: "A nova senha não pode ser igual à antiga!")

        } else {
            buttonState = .loading
            Task {
                do {
                    try await AuthenticationManager.shared.signInUser(email: userRepository.user?.email ?? "", password: currentPassword)
                    
                    try await AuthenticationManager.shared.updatePassword(password: newPassword)
                    buttonState = .idle
                    currentPassword = ""
                    newPassword = ""
                    confirmNewPassword = ""
                    configToast(type: .success, message: "Senha alterada com sucesso!")
                } catch {
                    buttonState = .idle
                    showErrorFirebase(error: error.localizedDescription)
                    print("Error updating password \(error.localizedDescription)")
                }
            }
        }
    }
    
    func showErrorFirebase(error: String) {
        switch error {
        case FirebaseError.credentialError.rawValue:
            configToast(type: .error, message: "A senha atual está incorreta.")
        case FirebaseError.passwordError.rawValue:
            configToast(type: .error, message: "A senha deve conter no mímimo 6 caracteres.")
        default:
            configToast(type: .error, message: "Erro ao tentar atualiza a senha. Gentileza tentar mais tarde.")
        }
    }
    
    enum FirebaseError: String {
        case credentialError = "The supplied auth credential is malformed or has expired."
        case passwordError = "The password must be 6 characters long or more."
    }
    
    func configToast(type: ToastType, message: String) {
        toastType = type
        toastMessage = message
        showToast = true
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
