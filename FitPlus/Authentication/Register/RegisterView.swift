//
//  RegisterView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 20/07/24.
//

import SwiftUI

struct RegisterView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmedPassword = ""
    @State private var fullName = ""
    @State private var showTrayError: TrayError = .idle
    @State private var shouldShowTray = false

    @StateObject private var viewModel = RegisterViewModel()
    @EnvironmentObject var userRepository: UserRepository
    @Environment(\.dismiss) var dismiss
    
    private var screenHeight = UIScreen.main.bounds.height

    var body: some View {
        NavigationStack {
            ZStack{
                Color.accentColor
                
                Text("Fit +")
                    .foregroundColor(.white)
                    .font(.system(size: 60))
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .offset(y: -(screenHeight < 700 ? screenHeight * 0.30 : screenHeight * 0.25))
                    .zIndex(1)
                
                VStack(spacing: 0) {
                    Color.accentColor
                        .frame(height: screenHeight < 700 ? screenHeight * 0.35 : screenHeight * 0.45)
                    
                    VStack(spacing: 0) {
                        
                        content
                        
                    }
                    .zIndex(1)
                    .padding(8)
                    .background(.white)
                    .clipShape(RoundedCorner(cornerRadius: 32, corners: [.topLeft, .topRight]))
                }
                .edgesIgnoringSafeArea(.top)
                
            }
            .ignoresSafeArea()
        }
    }
    
}

extension RegisterView {
        
    private var content: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .frame(height: UIScreen.main.bounds.height * 0.55)
                .foregroundStyle(.white)
            
            VStack {
                
                TextField("Digite seu nome completo", text: $fullName)
                    .textInputAutocapitalization(.words)
                    .modifier(TextFieldModifier())
                
                TextField("Digite seu e-mail", text: $email)
                    .textInputAutocapitalization(.never)
                    .modifier(TextFieldModifier())
                
                SecureField("Digite sua senha", text: $password)
                    .modifier(TextFieldModifier())
                
                SecureField("Confirme sua senha", text: $confirmedPassword)
                    .modifier(TextFieldModifier())
                
                Button {
                    guard !email.isEmpty, !password.isEmpty, !confirmedPassword.isEmpty else {
                        shouldShowTray.toggle()
                        showTrayError = .fillOutEveryField
                        return
                    }
                    
                    if !viewModel.isValidEmail(email) {
                        shouldShowTray.toggle()
                        showTrayError = .invalidEmail
                        return
                    }
                    
                    if !viewModel.checkPassword(password: password, confirmedPassword: confirmedPassword) {
                        shouldShowTray.toggle()
                        showTrayError = .passwordDoesNotMatch
                        return
                    }
                    
                    Task {
                        try await viewModel.signUp(
                            fullName: fullName,
                            email: email,
                            password: password,
                            confirmedPassword: confirmedPassword
                        )
                        try await userRepository.updateUser()

                    }
                } label: {
                    Text("Cadastrar")
                        .modifier(ButtonLabelModifier())
                }
                
                Divider()
                
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Text("Já tem uma conta?")
                            .foregroundStyle(.black)
                        
                        Text("Entrar")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.accentColor)
                    }
                }
                .padding(.vertical)
            }
            .frame(maxWidth: .infinity)
            .padding()
            
            if shouldShowTray {
                makeTray()
            }
        }
    }
    
    func makeTray() -> some View {
        VStack {
            VStack(spacing: 0) {
                
                HStack {
                    if showTrayError != .idle {
                        Text(showTrayError.rawValue)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.headline)
                            .foregroundStyle(.black)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            shouldShowTray.toggle()
                            showTrayError = .idle
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(8)
                    }
                    .background(Circle().fill(Color.gray.opacity(0.2)))
                }

            }
            .padding()
            .background(Color(red: 1.0, green: 0.8, blue: 0.8))
            .cornerRadius(16)
            .shadow(radius: 10)
            .frame(maxWidth: .infinity)
            .transition(.move(edge: .top))
            
            Spacer()
        }
        .padding()
        .animation(.easeInOut, value: shouldShowTray)
    }
}

#Preview {
    RegisterView()
}
