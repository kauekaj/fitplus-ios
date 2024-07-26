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
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                
                Color.accentColor
                
                VStack {
                    Spacer()
                    
                    Text("Fit +")
                        .foregroundColor(.white)
                        .font(.system(size: 60))
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                    
                    Spacer()
                    
                    content
                }
                
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
