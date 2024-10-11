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
    @StateObject private var viewModel = RegisterViewModel()
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
                
                TextField("Enter your full name ", text: $fullName)
                    .textInputAutocapitalization(.words)
                    .modifier(TextFieldModifier())
                
                TextField("Enter your e-mail", text: $email)
                    .textInputAutocapitalization(.never)
                    .modifier(TextFieldModifier())
                
                SecureField("Enter your password", text: $password)
                    .modifier(TextFieldModifier())
                
                SecureField("Confirm yor password", text: $confirmedPassword)
                    .modifier(TextFieldModifier())
                
                Button {
                    Task {
                        guard !email.isEmpty, !password.isEmpty else {
                            print("No email or password found")
                            return
                        }
                        try await viewModel.signUp(
                            email: email,
                            password: password,
                            confirmedPassword: confirmedPassword
                        )
                    }
                } label: {
                    Text("Sign Up")
                        .modifier(ButtonLabelModifier())
                }
                
                Divider()
                
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Text("Alerady have an account?")
                            .foregroundStyle(.black)
                        
                        Text("Sign In")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.accentColor)
                    }
                }
                .padding(.vertical)
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }
}

#Preview {
    RegisterView()
}
