//
//  RegisterView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 20/07/24.
//

import SwiftUI

struct RegisterView: View {
    
    @State private var emailInputText = ""
    @State private var passwordInputText = ""
    @State private var confirmedPasswordInputText = ""
    @State private var fullName = ""

    @State private var showTrayError: ToastError = .idle

    @State private var buttonState: ButtonState = .idle
    
    @StateObject private var viewModel = RegisterViewModel()
    @EnvironmentObject var userRepository: UserRepository
    @Environment(\.dismiss) var dismiss
    
    private var screenHeight = UIScreen.main.bounds.height

    var body: some View {
        NavigationStack {
            ZStack {
                Color.accentColor
                
                makeLogo()
                
                VStack(spacing: 0) {
                    Color.accentColor
                        .frame(height: screenHeight < 700 ? screenHeight * 0.45 : screenHeight * 0.55)
                    
                    VStack(spacing: 0) {
                        Spacer()
                        
                        content
                    }
                    .zIndex(1)
                    .padding(8)
                    .background(.white)
                    .clipShape(RoundedCorner(cornerRadius: 32, corners: [.topLeft, .topRight]))
                }
                .edgesIgnoringSafeArea(.top)
                
                if viewModel.showToast {
                    DSMToast(
                        message: viewModel.toastMessage,
                        type: viewModel.toastType,
                        autoDismiss: true
                    ) {
                        viewModel.showToast = false
                    }
                    .padding(.top, UIScreen.main.bounds.height * 0.06)
                    .zIndex(2)
                }
            }
            .ignoresSafeArea()
        }
    }
    
}

extension RegisterView {
    
    private var content: some View {
        
            VStack {
                TextField("Digite seu e-mail", text: $emailInputText)
                    .textInputAutocapitalization(.never)
                    .modifier(TextFieldModifier())
                    .padding(.top, 8)
                
                SecureField("Digite sua senha", text: $passwordInputText)
                    .modifier(TextFieldModifier())
                
                SecureField("Confirme sua senha", text: $confirmedPasswordInputText)
                    .modifier(TextFieldModifier())
                
                makeRegisterButton()
                
                Divider()
                                
                goToLogin()
            }
            .frame(maxWidth: .infinity)
            .padding()
    }
    
    func makeLogo() -> some View {
        Text("Fit +")
            .foregroundColor(.white)
            .font(.system(size: screenHeight < 700 ? 60 : 70))
            .fontWeight(.bold)
            .fontDesign(.rounded)
            .offset(y: -(screenHeight < 700 ? screenHeight * 0.25 : screenHeight * 0.20))
            .zIndex(1)
    }
    
    func makeRegisterButton() -> some View {
        DSMButton(title: "Cadastrar", state: $buttonState) {
            if viewModel.validateFields(email: emailInputText, password: passwordInputText, confirmedPassword: confirmedPasswordInputText) {
                buttonState = .loading
                Task {
                    defer {
                        buttonState = .idle
                    }
                    try await viewModel.signUp(
                        email: emailInputText,
                        password: passwordInputText,
                        confirmedPassword: confirmedPasswordInputText
                    )
                    
                    try await userRepository.updateUser()
                    
                }
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 16)

    }
    
    func goToLogin() -> some View {
        Button {
            dismiss()
            print(screenHeight)
        } label: {
            HStack {
                Text("Já tem uma conta?")
                    .foregroundStyle(.black)
                
                Text("Entrar")
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.accentColor)
            }
        }
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
}
