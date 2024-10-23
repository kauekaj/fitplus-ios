//
//  LoginView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 22/02/24.
//

import SwiftUI

struct LoginView: View {
        
    @State private var email = ""
    @State private var password = ""
    @State private var forgotPasswordInputText: String = ""
    @State private var shouldShowTray = false
    @State private var isResetPasswordEmailSent = false

    @EnvironmentObject var userRepository: UserRepository

    @StateObject private var viewModel = LoginViewModel()
    
    private var screenHeight = UIScreen.main.bounds.height

    var body: some View {
        
        NavigationView {
            ZStack {
                Color.accentColor
                
                makeLogo()

                VStack(spacing: 0) {
                    Color.accentColor
                        .frame(height: screenHeight < 700 ? screenHeight * 0.30 : screenHeight * 0.45)
                    
                    VStack(spacing: 0) {
                        content
                    }
                    .zIndex(1)
                    .padding(8)
                    .background(.white)
                    .clipShape(RoundedCorner(cornerRadius: 32, corners: [.topLeft, .topRight]))
                }
                .edgesIgnoringSafeArea(.top)
                
                if shouldShowTray == true {
                    makeTray()
                        .offset(y: (UIScreen.main.bounds.height * 0.50))
                }
            }
        }
    }
}

extension LoginView {
    
    private var content: some View {
                
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .frame(height: UIScreen.main.bounds.height * 0.55)
                .foregroundStyle(.white)
            
            VStack {
                TextField("E-mail", text: $email)
                    .textInputAutocapitalization(.never)
                    .modifier(TextFieldModifier())
                
                SecureField("Password", text: $password)
                    .modifier(TextFieldModifier())
                
                Button {
                    shouldShowTray.toggle()
                } label:  {
                        Text("Forgot password?")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.accentColor)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.vertical,4)
                }
                
                Button {
                    Task {
                        do {
                            try await viewModel.signIn(email: email, password: password)
                            try await userRepository.updateUser()

                        } catch {
                            print("Erro ao efetuar login: \(error)")
                        }
                    }

                } label: {
                    Text("Entrar")
                        .modifier(ButtonLabelModifier())
                }
                .padding(.bottom)
                
                Divider()
                
                alternativeLoginIcons
                    .padding(.vertical, 30)
                
                NavigationLink {
                    RegisterView()
                        .navigationBarBackButtonHidden()
                } label:  {
                    HStack {
                        Text("Ainda não tem uma conta?")
                            .foregroundStyle(.black)
                        
                        Text("Cadastrar")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.accentColor)
                    }
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }

    private var alternativeLoginIcons: some View {
        HStack(spacing: 40) {
            Button {
                
            } label: {
                Image("facebookIcon")
            }
            
            Button {
                
            } label: {
                Image("googleIcon")
            }
            
            Button {
                
            } label: {
                Image("appleIcon")
            }
        }
    }
    
    func makeLogo() -> some View {
        Text("Fit +")
            .foregroundColor(.white)
            .font(.system(size: 60))
            .fontWeight(.bold)
            .fontDesign(.rounded)
            .offset(y: -(screenHeight < 700 ? screenHeight * 0.35 : screenHeight * 0.25))
            .zIndex(1)
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
            .shadow(radius: 10)
            .frame(maxWidth: .infinity)
            .transition(.move(edge: .top))
            
            Spacer()
        }
        .zIndex(2)
        .padding()
        .animation(.easeInOut, value: shouldShowTray)
    }
    
}
